import 'package:flutter/material.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';
import '../failure/failure.dart';
// import '../../account/domain/models/character_entity.dart';
import '../patterns/result.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void, Failure>;
typedef UserResult = Result<User, Failure>;
// typedef CharacterResult = Result<Character,Failure>;
// typedef ListCharacterResult = Result<List<Character>, Failure>;

//typedefs para autenticação
typedef AuthSessionResult = Result<AuthSession, Failure>;

/// tipos usados para modulo de autenticação
typedef SignInParams = ({String email, String password});
typedef SignUpParams =
    ({String? name,String email, String password});

// typedfs para parâmetros
typedef UserParams = ({User user});

/// tipos usadoos Conta de Usuario
typedef NoParams = ();
typedef AccountNameParams = ({String accountName});
/// tipos usados para Personagem
typedef CharacterIdParams = ({String id});
// typedef CharacterParams = ({Character character});

/// typedefs para ser usados em componentes de UI
typedef FormFieldControl = ({
  GlobalKey<FormFieldState> key,
  FocusNode focus,
  TextEditingController controller,
});
