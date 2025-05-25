import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Model/profile_model.dart';
import '../Model/vehicle_model.dart';

class LocalDataSource {
  static const String _vehiclesKey = 'vehicles';
  static const String _profileKey = 'profile';
  static const String _tokenKey = 'token';
  static const String _rememberMeKey = 'remember_me';

  Future<void> cacheVehicles(List<VehicleModel> vehicles) async {
    final prefs = await SharedPreferences.getInstance();
    final vehiclesJson = vehicles.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList(_vehiclesKey, vehiclesJson);
  }

  Future<List<VehicleModel>> getCachedVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final vehiclesJson = prefs.getStringList(_vehiclesKey) ?? [];
    return vehiclesJson.map((json) => VehicleModel.fromJson(jsonDecode(json))).toList();
  }

  Future<void> cacheProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<ProfileModel?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    if (profileJson != null) {
      return ProfileModel.fromJson(jsonDecode(profileJson));
    }
    return null;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> setRememberMe(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, remember);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}