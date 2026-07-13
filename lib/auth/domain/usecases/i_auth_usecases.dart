import 'package:medquest/core/typedefs/type_defs.dart';

import '../../../core/patterns/i_usecases.dart';

abstract interface class ISignInUseCase
    implements IUseCase<AuthSessionResult, SignInParams> {}

// abstract interface class ISignInWithGoogleUseCase
//     implements IUseCase<AuthSessionResult, NoParams> {}

abstract interface class ISignOutUseCase
    implements IUseCase<VoidResult, NoParams> {}

abstract interface class ISignUpUseCase
    implements IUseCase<AuthSessionResult, SignUpParams> {}