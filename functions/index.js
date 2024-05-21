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
        tempBody: smartwatchData.bodyTemp,
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

exports.monitorVitalSigns = functions.firestore
    .document("SmartWatchEsp32/{docId}")
    .onWrite(async (change, context) => {
      // Données de la smartwatch mises à jour
      const newData = change.after.exists ? change.after.data() : null;
      if (!newData) {
        console.log("No data available");
        return null;
      }

      // Identifiant de la smartwatch pour récupérer l'enfant associé
      const smartwatchId = newData.smartwatchId;

      // Récupérer l'enfant lié à cette smartwatch
      const childrenRef = admin.firestore().collection("Children");
      const childSnapshot =
       await childrenRef.where("smartwatchId", "==", smartwatchId).get();

      if (childSnapshot.empty) {
        console.log("No child found for this smartwatch ID:", smartwatchId);
        return null;
      }

      // Supposons qu'il y ait un seul enfant par smartwatch
      const childData = childSnapshot.docs[0].data();

      // Préparer un message d'alerte si nécessaire
      let alertNeeded = false;
      let alertMessage =
      `Alerte pour ${childData.firstName} ${childData.lastName}: `;

      if (newData.bpm < childData.minBpm || newData.bpm > childData.maxBpm) {
        alertNeeded = true;
        alertMessage += `BPM hors de la plage autorisée (Actuel: ${newData.bpm},
        Attendu: ${childData.minBpm}-${childData.maxBpm}). `;
      }

      if (newData.spo2 < childData.minSpo2) {
        alertNeeded = true;
        alertMessage += `SpO2 trop bas (Actuel: ${newData.spo2},:
         ${childData.minSpo2}). `;
      }

      if (newData.temp <childData.minTemp || newData.temp > childData.maxTemp) {
        alertNeeded = true;
        alertMessage += `Température corporelle hors de la plage autorisée
        (Actuelle: ${newData.temp},
         Attendue: ${childData.minTemp}-${childData.maxTemp}). `;
      }

      // Envoyer une notification si une alerte est nécessaire
      if (alertNeeded) {
        const parentRef =
        admin.firestore().collection("Parents").doc(childData.parentId);
        const parentDoc = await parentRef.get();
        const parentData = parentDoc.data();

        if (!parentDoc.exists || !parentData.notify) {
          console.log("Parent notifications parent data not found");
          return null;
        }

        const message = {
          notification: {
            title: "Alerte de santé de l’enfant",
            body: alertMessage,
          },
          token: parentData.fcmToken,
        };

        return admin.messaging().send(message)
            .then((response) => {
              console.log("Successfully sent message:", response);
            })
            .catch((error) => {
              console.log("Error sending message:", error);
            });
      }

      return null;
    });

