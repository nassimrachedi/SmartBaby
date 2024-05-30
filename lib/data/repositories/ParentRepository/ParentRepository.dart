import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../../features/personalization/models/children_model.dart';
import '../authentication/authentication_repository.dart';

class ParentRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String parentId = AuthenticationRepository.instance.getUserID;

  Stream<List<ModelChild>> getChildrenForParent() {
    var parent1Stream = _db
        .collection('Children')
        .where('idParent1', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ModelChild.fromSnapshot(doc)).toList());

    var parent2Stream = _db
        .collection('Children')
        .where('idParent2', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ModelChild.fromSnapshot(doc)).toList());

    return Rx.combineLatest2<List<ModelChild>, List<ModelChild>, List<ModelChild>>(
      parent1Stream,
      parent2Stream,
          (parent1Children, parent2Children) {
        final combinedList = [...parent1Children, ...parent2Children];
        final childMap = {for (var child in combinedList) child.idChild: child};
        return childMap.values.toList();
      },
    );
  }

  Future<String?> getChildAssignedToParent() async {
    DocumentSnapshot parentDoc = await _db.collection('Parents').doc(parentId).get();
    if (parentDoc.exists && parentDoc.data() != null) {
      return parentDoc['ChildId'];
    }
    return null;
  }

  Future<void> selectChild(String childId) async {
    await _db.collection('Parents').doc(parentId).update({'ChildId': childId});
  }
}
