import '../../../core/patterns/usecases.dart';
import '../../../core/typedefs/type_defs.dart';

abstract interface class ICreatePatientUseCase
    implements IUseCase<PatientResult, PatientParams> {}

abstract interface class IGetPatientUseCase
    implements IUseCase<PatientResult, PatientIdParams> {}

    abstract interface class IGetPatientsUseCase
    implements IUseCase<PatientsResult, GroupIdParams> {}
    
abstract interface class IUpdatePatientUseCase
    implements IUseCase<PatientResult, PatientParams> {}


abstract interface class IDeletePatientUseCase
    implements IUseCase<VoidResult, PatientIdParams> {}
