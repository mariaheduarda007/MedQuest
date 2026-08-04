import 'package:flutter/material.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void, Failure>;
typedef UserResult = Result<User, Failure>;
typedef UserRolesResult = Result<List<UserRoleModel>, Failure>;

// typedefs para autenticação
typedef AuthSessionResult = Result<AuthSession, Failure>;

/// typedefs usados para modulo de autenticação
typedef SignInParams = ({String email, String password});
typedef SignUpParams =
    ({String? name,String email, String password});

// typedefs para parâmetros
typedef UserParams = ({User user});

// parâmetros para UserRole
typedef UserRolesParams = ({String userId});
typedef CreateUserRoleParams = ({String userId, String permissionId, String? researchId});
typedef UpdateUserRoleParams = ({String userRoleId, String? permissionId, String? researchId});
typedef DeleteUserRoleParams = ({String userRoleId});
typedef AllUserRolesResult = Result<List<UserRoleModel>, Failure>;

/// typedefs usados Conta de Usuario
typedef NoParams = ();

/// typedefs para ser usados em componentes de UI
typedef FormFieldControl = ({
  GlobalKey<FormFieldState> key,
  FocusNode focus,
  TextEditingController controller,
});
