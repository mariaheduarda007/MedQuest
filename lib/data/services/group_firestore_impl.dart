import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/data/services/group_firestore_interface.dart';
import 'package:medquest/domain/models/group_mapper.dart';
import '../../core/typedefs/type_defs.dart';
import '../../domain/models/group_entity.dart';

final class GroupFirestoreService implements IGroupFirestore {
  static const String _collection = 'Group';

  final FirebaseFirestore _firestore;

  GroupFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<GroupResult> createGroup(Group group, String researchId) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection(_collection)
          .add(GroupMapper.toMap(group));

      final groupCreated = await getGroup(researchId, snapshot.id);

      return groupCreated;
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao salvar grupo: $e'));
    }
  }

  @override
  Future<GroupResult> getGroup(String researchId, String groupId) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection(_collection)
          .doc(groupId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Error(EmptyResultFailure());
      }

      final group = GroupMapper.fromMap(snapshot.data()!);

      return Success(group);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter grupo: $e'));
    }
  }

  @override
  Future<GroupsResult> getGroups(String researchId) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection(_collection)
          .get();

      if (snapshot.docs.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final groups = snapshot.docs.map((doc) => GroupMapper.fromMap(doc.data())).toList();

      return Success(groups);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter grupo: $e'));
    }
  }

  @override
  Future<VoidResult> deleteGroup(String researchId, String groupId) async {
    try {
      await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .doc(groupId)
          .delete();

      return Success(null);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao deletar grupo: $e'));
    }
  }
}
