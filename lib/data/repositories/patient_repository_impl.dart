import '../../core/typedefs/type_defs.dart';
import 'patient_repository_interface.dart';
import '../services/patient_firestore_interface.dart';
import '../../domain/models/patient_entity.dart';

/// implementação do repositório para Patient

final class PatientRepositoryImpl implements IPatientRepository {
  final IPatientFirestore _firestore;

  PatientRepositoryImpl({required IPatientFirestore firestore})
    : _firestore = firestore;

  @override
  Future<PatientResult> createPatient(
    Patient patient,
    String researchId,
    String groupId,
  ) {
    return _firestore.createPatient(patient, researchId, groupId);
  }

  @override
  Future<PatientResult> getPatient(
    String researchId,
    String groupId,
    String patientId,
  ) {
    return _firestore.getPatient(researchId, groupId, patientId);
  }

  @override
  Future<PatientResult> updatePatient(
    Patient patient,
    String researchId,
    String groupId,
  ) {
    return _firestore.updatePatient(patient, researchId, groupId);
  }

  @override
  Future<VoidResult> deletePatient(
    String researchId,
    String groupId,
    String patientId,
  ) {
    return _firestore.deletePatient(researchId, groupId, patientId);
  }
}
