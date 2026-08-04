import 'package:medquest/core/patterns/i_usecases.dart';
import 'package:medquest/core/typedefs/type_defs.dart';

abstract interface class IGetUserRolesByUserIdUseCase
    implements IUseCase<UserRolesResult, UserRolesParams> {}

abstract interface class ICreateUserRoleUseCase
    implements IUseCase<VoidResult, CreateUserRoleParams> {}

abstract interface class IUpdateUserRoleUseCase
    implements IUseCase<VoidResult, UpdateUserRoleParams> {}

abstract interface class IDeleteUserRoleUseCase
    implements IUseCase<VoidResult, DeleteUserRoleParams> {}

abstract interface class IGetAllUserRolesUseCase
    implements IUseCase<AllUserRolesResult, NoParams> {}