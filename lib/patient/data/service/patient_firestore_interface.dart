import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';

import '../../../core/typedefs/type_defs.dart';
import '../../domain/models/patient_entity.dart';

abstract interface class IPatientFirestore {
  Future<PatientResult> createPatient(
    Patient patient,
    String researchId,
    String groupId,
  );
  Future<PatientResult> getPatient(
    String researchId,
    String groupId,
    String patientId,
  );
  Future<PatientsResult> getPatients(String researchId, String groupId);
  Future<PatientResult> updatePatient(
    Patient patient,
    String researchId,
    String groupId,
  );
  Future<VoidResult> deletePatient(
    String researchId,
    String groupId,
    String patientId,
  );
  
}
