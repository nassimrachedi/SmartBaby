
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ModelChild{
  final String idChild;
  String FirstNamech;
  String LastNamech;
  DateTime DateNais;
  String Seuilbpm;
  String SeuilSpo2;
  String SeuilTemp;
  String Genre;
  String profilePictureC;

  ModelChild({
    required this.idChild,
    required this.FirstNamech,
    required this.LastNamech,
    required this.DateNais,
    required this.SeuilSpo2,
    required this.Genre,
    required this.Seuilbpm,
    required this.SeuilTemp,
    required this.profilePictureC,
});
  Map<String, dynamic> toJson() {
    return {
      'FirstName': FirstNamech,
      'LastName': LastNamech,
      'Genre': Genre,
      'DateDeNaissance': DateNais,
      'Seuilmaxbpm': Seuilbpm,
      'ProfilePicture': profilePictureC,
      'Seuilmaxspo2': SeuilSpo2,
      'Seuilmaxtemp': SeuilTemp,

    };
  }


  factory ModelChild.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return ModelChild(
        idChild: document.id,
        FirstNamech: data['FirstName'] ?? '',
        LastNamech: data['LastName'] ?? '',
        Genre: data['Genre'] ?? '',
        DateNais: data['DateDeNaissance'] ?? '',
        profilePictureC: data['ProfilePictureC'] ?? '',
        Seuilbpm: data['Seuilmaxbpm'] ?? '',
        SeuilSpo2:data['Seuilmaxspo2'] ?? '',
        SeuilTemp:data['Seuilmaxtemp'] ?? '',
      );
    } else {
      return ModelChild.empty();
    }
  }
  static ModelChild empty() => ModelChild(idChild: '', FirstNamech: '', LastNamech: '', SeuilSpo2: '', Genre: '', Seuilbpm: '', SeuilTemp: '', profilePictureC: '', DateNais: DateTime.now());
}