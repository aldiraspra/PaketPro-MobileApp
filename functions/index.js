const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendPackageStatusNotification = functions.database.ref('/conveyor/paket_sort/{paketId}')
  .onCreate((snapshot, context) => {
    const paket = snapshot.val();
    const payload = {
      notification: {
        title: 'Paket Tersortir',
        body: `Paket ${paket.id} telah tersortir di ${paket.jalur}.`,
      },
    };
    return admin.messaging().sendToTopic('paket-status', payload);
  });
