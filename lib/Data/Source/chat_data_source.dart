import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/chat_model.dart';
import '../Model/message_model.dart';

class ChatDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> startChat(String vehicleId, String ownerId) async {
    final renterId = _auth.currentUser?.uid;
    if (renterId == null) throw Exception('User not authenticated');

    final chatQuery = await _firestore
        .collection('chats')
        .where('vehicleId', isEqualTo: vehicleId)
        .where('renterId', isEqualTo: renterId)
        .where('ownerId', isEqualTo: ownerId)
        .get();

    if (chatQuery.docs.isNotEmpty) {
      return chatQuery.docs.first.id;
    }

    final chatRef = await _firestore.collection('chats').add({
      'vehicleId': vehicleId,
      'renterId': renterId,
      'ownerId': ownerId,
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
      'participants': [renterId, ownerId],
    });

    return chatRef.id;
  }

  Future<void> sendMessage(String chatId, String text) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': userId,
      'text': text,
      'timestamp': Timestamp.now(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': Timestamp.now(),
    });
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<List<ChatModel>> getChats() {
    final userId = _auth.currentUser?.uid;
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatModel.fromJson(doc.data(), doc.id))
        .toList());
  }
}