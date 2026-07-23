import '../../core/typedefs/type_defs.dart';
import 'patient_repository_interface.dart';
import '../services/patient_firestore_interface.dart';
import '../../domain/models/patient_entity.dart';

/// implementação do repositório para Patient

final class PatientRepositoryImpl implements IPatientRepository {
  final IPatientFirestore _localStorage;

  PatientRepositoryImpl({required IPatientFirestore localStorage})
    : _localStorage = localStorage;

  @override
  Future<PatientResult> createPatient(
    Patient patient,
    String researchId,
    String groupId,
  ) {
    return _localStorage.createPatient(patient, researchId, groupId);
  }

  @override
  Future<PatientResult> getPatient(
    String researchId,
    String groupId,
    String patientId,
  ) {
    return _localStorage.getPatient(researchId, groupId, patientId);
  }

  @override
  Future<PatientResult> updatePatient(
    Patient patient,
    String researchId,
    String groupId,
  ) {
    return _localStorage.updatePatient(patient, researchId, groupId);
  }

  @override
  Future<VoidResult> deletePatient(
    String researchId,
    String groupId,
    String patientId,
  ) {
    return _localStorage.deletePatient(researchId, groupId, patientId);
  }
}
