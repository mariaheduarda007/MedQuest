import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/data/services/patient_firestore_interface.dart';
import 'package:medquest/domain/models/patient_entity.dart';
import 'package:medquest/domain/models/patient_mapper.dart';
import '../../core/failure/failure.dart';
import '../../core/patterns/result.dart';

final class PatientFirestoreService implements IPatientFirestore {
  static const String _collection = 'Patient';

  final FirebaseFirestore _firestore;

  PatientFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<PatientResult> createPatient(
    Patient patient,
    String researchId,
    String groupId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .doc(groupId)
          .collection(_collection)
          .add(PatientMapper.toMap(patient));

      final patientCreated = await getPatient(researchId, groupId, snapshot.id);

      return patientCreated;
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao salvar paciente: $e'));
    }
  }

  @override
  Future<PatientResult> getPatient(
    String researchId,
    String groupId,
    String patientId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .doc(groupId)
          .collection(_collection)
          .doc(patientId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Error(EmptyResultFailure());
      }

      final patient = PatientMapper.fromMap(snapshot.data()!);

      return Success(patient);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter paciente: $e'));
    }
  }

  @override
  Future<PatientsResult> getPatients(String researchId, String groupId) async {
    try {
      final snapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .doc(groupId)
          .collection(_collection)
          .get();

      if (snapshot.docs.isEmpty) {
        return Error(EmptyResultFailure());
      }

      final patients = snapshot.docs
          .map((doc) => PatientMapper.fromMap(doc.data()))
          .toList();

      return Success(patients);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter pacientes: $e'));
    }
  }

  @override
  Future<PatientResult> updatePatient(
    Patient patient,
    String researchId,
    String groupId,
  ) async {
    try {
      await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .doc(groupId)
          .collection(_collection)
          .doc(patient.id)
          .update(PatientMapper.toMap(patient));

      final updatedPatient = await getPatient(researchId, groupId, patient.id);

      return updatedPatient;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao atualizar paciente: $e'),
      );
    }
  }

  @override
  Future<VoidResult> deletePatient(
    String researchId,
    String groupId,
    String patientId,
  ) async {
    try {
      await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .doc(groupId)
          .collection(_collection)
          .doc(patientId)
          .delete();

      return Success(null);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao deletar paciente: $e'));
    }
  }
}
