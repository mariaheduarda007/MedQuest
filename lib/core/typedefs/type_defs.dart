import 'package:flutter/material.dart';
import '../failure/failure.dart';

import '../patterns/result.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void, Failure>;
// typedef AccountResult = Result<Account, Failure>;


// typedfs para parâmetros
// typedef AccountParams = ({Account account});

/// tipos usadoos Conta de Usuario
typedef NoParams = ();
// typedef AccountNameParams = ({String accountName});
/// tipos usados para Personagem


/// typedefs para ser usados em componentes de UI
typedef FormFieldControl = ({
  GlobalKey<FormFieldState> key,
  FocusNode focus,
  TextEditingController controller,
});


// typedefs para tipo Result
// typedefs para autenticação


// typedfs para parâmetros
/// tipos usadoos para modulo de autenticação
typedef SignInParams = ({String email, String password});
typedef SignUpParams =
    ({String? name,String email, String password});
