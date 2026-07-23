import '../../core/typedefs/type_defs.dart';

abstract interface class IPatientFacadeUseCases {
  Future<PatientResult> createPatient(PatientParams params);
  Future<PatientResult> getPatient(PatientIdParams params);
  Future<PatientResult> updatePatient(PatientParams params);
  Future<VoidResult> deletePatient(PatientIdParams params);
}
