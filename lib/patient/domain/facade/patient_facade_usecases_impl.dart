import '../../../core/typedefs/type_defs.dart';
import 'patient_facade_usecases_interface.dart';
import '../usecases/patient_usecases_interface.dart';

final class PatientFacadeUsecasesImpl implements IPatientFacadeUseCases {
  final ICreatePatientUseCase _createPatientUseCase;
  final IGetPatientUseCase _getPatientUseCase;
  final IGetPatientsUseCase _getPatientsUseCase;
  final IUpdatePatientUseCase _updatePatientUseCase;
  final IDeletePatientUseCase _deletePatientUseCase;

  PatientFacadeUsecasesImpl({
    required ICreatePatientUseCase createPatientUseCase,
    required IGetPatientUseCase getPatientUseCase,
    required IGetPatientsUseCase getPatientsUseCase,
    required IUpdatePatientUseCase updatePatientUseCase,
    required IDeletePatientUseCase deletePatientUseCase,
  }) : _createPatientUseCase = createPatientUseCase,
       _getPatientUseCase = getPatientUseCase,
       _getPatientsUseCase = getPatientsUseCase,
       _updatePatientUseCase = updatePatientUseCase,
       _deletePatientUseCase = deletePatientUseCase;

  @override
  Future<PatientResult> createPatient(PatientParams params) {
    return _createPatientUseCase(params);
  }

  @override
  Future<PatientResult> getPatient(PatientIdParams params) {
    return _getPatientUseCase(params);
  }

  @override
  Future<PatientsResult> getPatients(GroupIdParams params) {
    return _getPatientsUseCase(params);
  }

  @override
  Future<PatientResult> updatePatient(PatientParams params) {
    return _updatePatientUseCase(params);
  }

  @override
  Future<VoidResult> deletePatient(PatientIdParams params) {
    return _deletePatientUseCase(params);
  }

  
}
