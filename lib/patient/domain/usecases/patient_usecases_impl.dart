import '../../../core/typedefs/type_defs.dart';
import '../../data/repository/patient_repository_interface.dart';
import 'patient_usecases_interface.dart';

final class CreatePatientUseCaseImpl implements ICreatePatientUseCase {
  final IPatientRepository _repository;

  CreatePatientUseCaseImpl({required IPatientRepository repository})
    : _repository = repository;

  @override
  Future<PatientResult> call(PatientParams params) async {
    return _repository.createPatient(
      params.patient,
      params.researchId,
      params.groupId,
    );
  }
}

final class GetPatientUseCaseImpl implements IGetPatientUseCase {
  final IPatientRepository _repository;

  GetPatientUseCaseImpl({required IPatientRepository repository})
    : _repository = repository;

  @override
  Future<PatientResult> call(PatientIdParams params) async {
    return _repository.getPatient(
      params.researchId,
      params.groupId,
      params.patientId,
    );
  }
}

final class GetPatientsUseCaseImpl implements IGetPatientsUseCase {
  final IPatientRepository _repository;

  GetPatientsUseCaseImpl({required IPatientRepository repository})
    : _repository = repository;

  @override
  Future<PatientsResult> call(GroupIdParams params) async {
    return _repository.getPatients(
      params.researchId,
      params.groupId,
    );
  }
}

final class UpdatePatientUseCaseImpl implements IUpdatePatientUseCase {
  final IPatientRepository _repository;

  UpdatePatientUseCaseImpl({required IPatientRepository repository})
    : _repository = repository;

  @override
  Future<PatientResult> call(PatientParams params) async {
    return _repository.updatePatient(
      params.patient,
      params.researchId,
      params.groupId,
    );
  }
}


final class DeletePatientUseCaseImpl implements IDeletePatientUseCase {
  final IPatientRepository _repository;

  DeletePatientUseCaseImpl({required IPatientRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(PatientIdParams params) async {
    return _repository.deletePatient(
      params.researchId,
      params.groupId,
      params.patientId,
    );
  }
}
