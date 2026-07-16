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
    // Observers para cada comando
    _observeGetUser();
    _observeDeleteUser();
    _observeSaveUser();
    _observeUpdateUser();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
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
      // 1) Ignora enquanto está executando
      if (command.isExecuting.value) return;

      // 2) Ignora até existir um resultado
      final result = command.result.value;
      if (result == null) return;

      // 3) Sucesso ou falha
      result.fold(
        onSuccess: (data) {
          state.clearMessage(); // sempre limpa erros em sucesso
          onSuccess(data); // ação específica para esse comando
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
        onFailure: (err) {
          state.setMessage(err.msg); // registra o erro no estado
          if (onFailure != null) onFailure(err);
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  // Recuperar User
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
        state.clearMessage(); // Limpa mensagens anteriores
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
        state.clearMessage(); // Limpa mensagens anteriores
        
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS (CHAMADOS PELOS WIDGETS)
  //   que disparam os commands
  // ========================================================
  Future<void> fetchUser() async {
    state.clearMessage(); // Limpa mensagens anteriores
    await _getUserCommand.executeWith(());
  }

  Future<void> deleteUser() async {
    state.clearMessage(); // Limpa mensagens anteriores
    await _deleteUserCommand.executeWith(());
  }

  Future<void> saveUser(User user) async {
    state.setUser(user); // Atualiza o estado
    await _saveUserCommand.executeWith((user: user));
  }

  Future<void> updateUser(User user) async {
    state.setUser(user); // Atualiza o estado
    await _updateUserCommand.executeWith((user: user));
  }
}
