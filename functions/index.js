const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyVehicleAdded = functions.firestore
  .document('vehicles/{vehicleId}')
  .onCreate((snap, _context) => {
    const vehicle = snap.data();
    const payload = {
      notification: {
        title: 'New Vehicle Added',
        body: `Vehicle ${vehicle.name} has been added.`,
      },
    };
    return admin.messaging().sendToTopic('vehicles', payload);
  });

exports.notifyRentalStarted = functions.firestore
  .document('rentals/{rentalId}')
  .onCreate((snap, _context) => {
    const rental = snap.data();
    return admin.firestore().collection('vehicles').doc(rental.vehicleId).get()
      .then(doc => {
        const vehicle = doc.data();
        const payload = {
          notification: {
            title: 'Rental Started',
            body: `Rental for ${vehicle.name} has started.`,
          },
        };
        return admin.messaging().sendToTopic(`vehicle_${rental.vehicleId}`, payload);
      });
  });

exports.notifyRentalEnding = functions.pubsub.schedule('every 5 minutes').onRun(async (_context) => {
  const now = admin.firestore.Timestamp.now();
  const fiveMinFromNow = new Date(now.toDate().getTime() + 5 * 60 * 1000);
  const rentals = await admin.firestore()
    .collection('rentals')
    .where('endTime', '<=', admin.firestore.Timestamp.fromDate(fiveMinFromNow))
    .where('endTime', '>=', now)
    .get();
  for (const doc of rentals.docs) {
    const rental = doc.data();
    const vehicleDoc = await admin.firestore().collection('vehicles').doc(rental.vehicleId).get();
    const vehicle = vehicleDoc.data();
    const payload = {
      notification: {
        title: 'Rental Ending Soon',
        body: `Rental for ${vehicle.name} ends in 5 minutes.`,
      },
    };
    await admin.messaging().sendToTopic(`vehicle_${rental.vehicleId}`, payload);
  }
  return null;
});