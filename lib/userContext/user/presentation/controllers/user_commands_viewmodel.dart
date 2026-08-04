import 'package:signals_flutter/signals_flutter.dart';
import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/command.dart';
import 'package:medquest/auth/domain/models/auth_entities.dart';
import 'package:medquest/userContext/user/presentation/commands/user_commands.dart';
import 'package:medquest/userContext/user/presentation/controllers/user_state_viewmodel.dart';

class UserCommandsViewmodel {
  final UserStateViewModel state;
  final GetUserCommand _getUserCommand;
  final SaveUserCommand _saveUserCommand;
  final UpdateUserCommand _updateUserCommand;
  final DeleteUserCommand _deleteUserCommand;

  UserCommandsViewmodel({
    required this.state,
    required GetUserCommand getUserCommand,
    required SaveUserCommand saveUserCommand,
    required UpdateUserCommand updateUserCommand,
    required DeleteUserCommand deleteUserCommand,
  }) : _getUserCommand = getUserCommand,
       _saveUserCommand = saveUserCommand,
       _updateUserCommand = updateUserCommand,
       _deleteUserCommand = deleteUserCommand {
    _observeGetUser();
    _observeDeleteUser();
    _observeSaveUser();
    _observeUpdateUser();
  }

  GetUserCommand get getUserCommand => _getUserCommand;
  SaveUserCommand get saveUserCommand => _saveUserCommand;
  UpdateUserCommand get updateUserCommand => _updateUserCommand;
  DeleteUserCommand get deleteUserCommand => _deleteUserCommand;

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
          state.setMessage(err.msg);
          if (onFailure != null) onFailure(err);
          command.clear();
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  // recuperar User
  void _observeGetUser() {
    _observeCommand<User>(
      _getUserCommand,
      onSuccess: (user) {
        state.setUser(user);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // deletar User
  void _observeDeleteUser() {
    _observeCommand<void>(
      _deleteUserCommand,
      onSuccess: (_) {
        state.successEvent.value = UserSuccessEvent.deleted;
        state.setUser(null); 
        
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }
 // salvar User
  void _observeSaveUser() {
    _observeCommand<void>(
      _saveUserCommand,
      onSuccess: (_) {
        state.successEvent.value = UserSuccessEvent.created;
        state.clearMessage(); 
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // atualizar User
  void _observeUpdateUser() {
    _observeCommand<void>(
      _updateUserCommand,
      onSuccess: (_) {
        state.successEvent.value = UserSuccessEvent.updated;
        state.clearMessage(); 
        
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  Future<void> fetchUser() async {
    state.clearMessage(); 
    await _getUserCommand.executeWith(());
  }

  Future<void> deleteUser() async {
    state.clearMessage(); 
    await _deleteUserCommand.executeWith(());
  }

  Future<void> saveUser(User user) async {
    state.setUser(user); 
    await _saveUserCommand.executeWith((user: user));
  }

  Future<void> updateUser(User user) async {
    state.setUser(user);
    await _updateUserCommand.executeWith((user: user));
  }
}
