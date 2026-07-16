import 'package:medquest/core/patterns/i_usecases.dart';
import 'package:medquest/core/typedefs/type_defs.dart';

abstract interface class IGetUserUseCase
    implements IUseCase<UserResult, NoParams> {}

abstract interface class ISaveUserUseCase
    implements IUseCase<VoidResult, UserParams> {}

abstract interface class IDeleteUserUseCase
    implements IUseCase<VoidResult, NoParams> {}

abstract interface class IUpdateUserUseCase
    implements IUseCase<VoidResult, UserParams> {}
