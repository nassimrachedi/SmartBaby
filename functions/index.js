const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.storeSmartwatchData = functions.firestore
    .document("SmartWatchEsp32/pfe2024")
    .onWrite(async (change, context) => {
      const smartwatchData = change.after.exists ? change.after.data() : null;

      if (!smartwatchData) {
        console.log("Aucune donnée mise à jour pour la smartwatch pfe2024.");
        return null;
      }

      const childrenRef = admin.firestore().collection("Children");
      const childSnapshot = await childrenRef
          .where("smartwatchId", "==", "pfe2024")
          .limit(1)
          .get();


      if (childSnapshot.empty) {
        console.log("Aucun enfant associé à la smartwatch pfe2024.");
        return null;
      }


      const childDoc = childSnapshot.docs[0];
      const childId = childDoc.id;


      const healthData = {
        spo2: smartwatchData.spo2,
        bodyTemp: smartwatchData.bodyTemp,
        bpm: smartwatchData.bpm,
        temp: smartwatchData.temp,
        humidity: smartwatchData.humidity,
        heure: admin.firestore.FieldValue.serverTimestamp(),
      };


      return admin.firestore()
          .collection("Children")
          .doc(childId)
          .collection("EtatSante")
          .add(healthData)
          .then(() => console.log("Données l'enfant: ", childId))
          .catch((error) => console.error("Erreur santé", error));
    });
