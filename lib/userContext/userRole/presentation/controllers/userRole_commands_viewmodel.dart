import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/command.dart';
import '../commands/userRole_commands.dart';
import '../controllers/userRole_state_viewmodel.dart';

class UserRoleCommandsViewmodel {
  final UserRoleStateViewModel state;
  final GetUserRolesByUserIdCommand _getUserRolesCommand;
  final CreateUserRoleCommand _createUserRoleCommand;
  final UpdateUserRoleCommand _updateUserRoleCommand;
  final DeleteUserRoleCommand _deleteUserRoleCommand;
  final GetAllUserRolesCommand _getAllUserRolesCommand;

  UserRoleCommandsViewmodel({
    required this.state,
    required GetUserRolesByUserIdCommand getUserRolesCommand,
    required CreateUserRoleCommand createUserRoleCommand,
    required UpdateUserRoleCommand updateUserRoleCommand,
    required DeleteUserRoleCommand deleteUserRoleCommand,
    required GetAllUserRolesCommand getAllUserRolesCommand,
  })  : _getUserRolesCommand = getUserRolesCommand,
        _createUserRoleCommand = createUserRoleCommand,
        _updateUserRoleCommand = updateUserRoleCommand,
        _deleteUserRoleCommand = deleteUserRoleCommand,
        _getAllUserRolesCommand = getAllUserRolesCommand {
    _observeGetUserRoles();
    _observeCreateUserRole();
    _observeUpdateUserRole();
    _observeDeleteUserRole();
    _observeGetAllUserRoles();
  }

  GetUserRolesByUserIdCommand get getUserRolesCommand => _getUserRolesCommand;
  CreateUserRoleCommand get createUserRoleCommand => _createUserRoleCommand;
  UpdateUserRoleCommand get updateUserRoleCommand => _updateUserRoleCommand;
  DeleteUserRoleCommand get deleteUserRoleCommand => _deleteUserRoleCommand;
  GetAllUserRolesCommand get getAllUserRolesCommand => _getAllUserRolesCommand;

  // ========================================================
  //   MÉTODO GENÉRICO DE OBSERVAÇÃO DE COMANDOS
  // ========================================================
  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      if (command.isExecuting.value) return;

      final result = command.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (data) {
          state.clearMessage();
          onSuccess(data);
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg); // registra o erro no estado
          if (onFailure != null) onFailure(err);
          command.clear();
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  // recuperar Roles por User ID
  void _observeGetUserRoles() {
    _observeCommand<List<UserRoleModel>>(
      _getUserRolesCommand,
      onSuccess: (roles) {
        state.setUserRoles(roles);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // criar User Role
  void _observeCreateUserRole() {
    _observeCommand<void>(
      _createUserRoleCommand,
      onSuccess: (_) {
        state.successEvent.value = UserRoleSuccessEvent.created;
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // atualizar User Role
  void _observeUpdateUserRole() {
    _observeCommand<void>(
      _updateUserRoleCommand,
      onSuccess: (_) {
        state.successEvent.value = UserRoleSuccessEvent.updated;
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // deletar User Role
  void _observeDeleteUserRole() {
    _observeCommand<void>(
      _deleteUserRoleCommand,
      onSuccess: (_) {
        state.successEvent.value = UserRoleSuccessEvent.deleted;
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // pegar todas as User Roles
  void _observeGetAllUserRoles() {
    _observeCommand<List<UserRoleModel>>(
      _getAllUserRolesCommand,
      onSuccess: (roles) {
        state.setUserRoles(roles);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  Future<void> fetchUserRoles(String userId) async {
    state.clearMessage();
    await _getUserRolesCommand.executeWith((userId: userId));
  }

  Future<void> createUserRole({
    required String userId,
    required String permissionId,
    String? researchId,
  }) async {
    state.clearMessage();
    await _createUserRoleCommand.executeWith((
      userId: userId,
      permissionId: permissionId,
      researchId: researchId,
    ));
  }

  Future<void> updateUserRole({
    required String userRoleId,
    String? permissionId,
    String? researchId,
  }) async {
    state.clearMessage();
    await _updateUserRoleCommand.executeWith((
      userRoleId: userRoleId,
      permissionId: permissionId,
      researchId: researchId,
    ));
  }

  Future<void> deleteUserRole(String userRoleId) async {
    state.clearMessage();
    await _deleteUserRoleCommand.executeWith((userRoleId: userRoleId));
  }

  Future<void> fetchAllUserRoles() async {
    state.clearMessage();
    await _getAllUserRolesCommand.executeWith(());
  }
}