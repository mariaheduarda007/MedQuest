import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import '../../core/patterns/result.dart';
import '../../core/typedefs/type_defs.dart';
import '../../domain/facades/patient_facade_usecases_interface.dart';
import '../../domain/models/patient_entity.dart';

final class CreatePatientCommand
    extends ParameterizedCommand<Patient, Failure, PatientParams> {
  final IPatientFacadeUseCases _patientFacadeUseCases;

  CreatePatientCommand(this._patientFacadeUseCases);

  @override
  Future<PatientResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar paciente.'));
    }

    return await _patientFacadeUseCases.createPatient(parameter!);
  }
}

final class GetPatientCommand
    extends ParameterizedCommand<Patient, Failure, PatientIdParams> {
  final IPatientFacadeUseCases _patientFacadeUseCases;

  GetPatientCommand(this._patientFacadeUseCases);

  @override
  Future<PatientResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar paciente.'));
    }
    return await _patientFacadeUseCases.getPatient(parameter!);
  }
}

final class GetPatientsCommand
    extends ParameterizedCommand<List<Patient>, Failure, GroupIdParams> {
  final IPatientFacadeUseCases _patientFacadeUseCases;

  GetPatientsCommand(this._patientFacadeUseCases);

  @override
  Future<PatientsResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar pacientes.'));
    }
    return await _patientFacadeUseCases.getPatients(parameter!);
  }
}

final class UpdatePatientCommand
    extends ParameterizedCommand<Patient, Failure, PatientParams> {
  final IPatientFacadeUseCases _patientFacadeUseCases;

  UpdatePatientCommand(this._patientFacadeUseCases);

  @override
  Future<PatientResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para atualizar paciente.'));
    }
    return await _patientFacadeUseCases.updatePatient(parameter!);
  }
}


final class DeletePatientCommand
    extends ParameterizedCommand<void, Failure, PatientIdParams> {
  final IPatientFacadeUseCases _patientFacadeUseCases;

  DeletePatientCommand(this._patientFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para excluir paciente.'));
    }
    return await _patientFacadeUseCases.deletePatient(parameter!);
  }
}
