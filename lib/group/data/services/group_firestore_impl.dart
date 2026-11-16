import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/group/data/services/group_firestore_interface.dart';
import 'package:medquest/group/domain/models/group_mapper.dart';
import '../../../core/typedefs/type_defs.dart';
import '../../domain/models/group_entity.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';
import 'package:medquest/patient/domain/models/patient_mapper.dart';

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

      return Success(group.copyWith(id: snapshot.id));
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

      final group = GroupMapper.fromMap(snapshot.data()!, snapshot.id);
      // final patientCount = await _getPatientCount(snapshot.reference);

      final patientsList = await _getPatients(snapshot.reference);

      return Success(
        group.copyWith(
          patients: patientsList,
          patientCount: patientsList.length,
        ),
      );
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

      final groups = await Future.wait(
        snapshot.docs.map((doc) async {
          final group = GroupMapper.fromMap(doc.data(), doc.id);
          // final patientCount = await _getPatientCount(doc.reference);

          final patientsList = await _getPatients(doc.reference);
          return group.copyWith(
            patients: patientsList,
            patientCount: patientsList.length,
          );
        }),
      );

      return Success(groups);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter grupo: $e'));
    }
  }

  Future<int> _getPatientCount(
    DocumentReference<Map<String, dynamic>> group,
  ) async {
    final snapshot = await group.collection('Patient').count().get();
    return snapshot.count ?? 0;
  }

  Future<List<Patient>> _getPatients(
    DocumentReference<Map<String, dynamic>> group,
  ) async {
    final snapshot = await group.collection('Patient').get();

    if (snapshot.docs.isEmpty) return [];

    return snapshot.docs.map((doc) {
      return PatientMapper.fromMap(doc.data(), documentId: doc.id);
    }).toList();
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
