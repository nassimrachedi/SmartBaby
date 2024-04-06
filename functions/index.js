const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.processNewSmartwatchUpdate = functions.firestore
    .document("SmartWatchEsp32Updates/{updateId}")
    .onCreate(async (snapshot, context) => {
      const smartwatchRef =
      admin.firestore().collection("SmartWatchEsp32").doc("pfe2024");
      const smartwatchData = (await smartwatchRef.get()).data();

      if (!smartwatchData) {
        console.log("Aucune donnée trouvée pour la smartwatch spécifiée.");
        return null;
      }

      const childrenSnapshot = await admin.firestore().collection("Children")
          .where("smartwatchId", "==", "pfe2024")
          .limit(1)
          .get();

      if (childrenSnapshot.empty) {
        console.log("Aucun enfant associé à cette smartwatch.");
        return null;
      }

      const childRef = childrenSnapshot.docs[0].ref;
      const healthData = {
        SpO2: smartwatchData.Spo2,
        Temperature: smartwatchData.Temp,
        BPM: smartwatchData.Bpm,
        Heure: admin.firestore.FieldValue.serverTimestamp(),
      };

      await childRef.collection("EtatSante").add(healthData);
      console.log("Données de santé stockées pour l'enfant.");
      return null;
    });
