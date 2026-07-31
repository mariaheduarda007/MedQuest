import 'package:medquest/group/domain/models/group_entity.dart';
import 'package:medquest/group/presentation/commands/group_commands.dart';
import 'package:medquest/group/presentation/controllers/group_state_viewmodel.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GroupCommandsViewModel {
  final GroupStateViewModel state;
  final CreateGroupCommand _createGroupCommand;
  final GetGroupCommand _getGroupCommand;
  final GetGroupsCommand _getGroupsCommand;
  final DeleteGroupCommand _deleteGroupCommand;

  GroupCommandsViewModel({
    required this.state,
    required GetGroupCommand getGroupCommand,
    required GetGroupsCommand getGroupsCommand,
    required CreateGroupCommand createGroupCommand,
    required DeleteGroupCommand deleteGroupCommand,
  }) : _createGroupCommand = createGroupCommand,
       _getGroupCommand = getGroupCommand,
       _getGroupsCommand = getGroupsCommand,
       _deleteGroupCommand = deleteGroupCommand {
    // Observers para cada comando
    _observeCreateGroup();
    _observeGetGroup();
    _observeGetGroups();
    _observeDeleteGroup();
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  CreateGroupCommand get createGroupCommand => _createGroupCommand;
  GetGroupCommand get getGroupCommand => _getGroupCommand;
  GetGroupsCommand get getGroupsCommand => _getGroupsCommand;
  DeleteGroupCommand get deleteGroupCommand => _deleteGroupCommand;

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

      result.fold(
        onSuccess: (data) {
          state.clearMessage();
          onSuccess(data);
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg);
          if (onFailure != null) onFailure(err);
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  void _observeCreateGroup() {
    _observeCommand<Group>(
      _createGroupCommand,
      onSuccess: (group) {
        state.setGroup(group);
        state.successEvent.value = GroupSuccessEvent.created;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetGroup() {
    _observeCommand<Group>(
      _getGroupCommand,
      onSuccess: (group) {
        state.setGroup(group);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      }, //redundante, pois o generico já faz isso, mas mantido para verificar minha suposição
    );
  }

  void _observeGetGroups() {
    _observeCommand<List<Group>>(
      _getGroupsCommand,
      onSuccess: (groups) {
        state.setGroups(groups);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeDeleteGroup() {
    _observeCommand<void>(
      _deleteGroupCommand,
      onSuccess: (_) {
        state.successEvent.value = GroupSuccessEvent.deleted;
        state.setGroup(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS QUE DISPARAM COMMANDS (CHAMADOS PELOS WIDGETS)
  // ========================================================
  Future<void> createGroup(Group group, String researchId) async {
    //só executa o command, state e suas funções são atualizados pelos observers
    await _createGroupCommand.executeWith((
      group: group,
      researchId: researchId,
    ));
  }

  Future<void> getGroup(String researchId, String groupId) async {
    await _getGroupCommand.executeWith((
      researchId: researchId,
      groupId: groupId,
    ));
  }

  Future<void> getGroups(String researchId) async {
    await _getGroupsCommand.executeWith((
      researchId: researchId,
    ));
  }

  Future<void> deleteGroup(String researchId, String groupId) async {
    await _deleteGroupCommand.executeWith((
      groupId: groupId,
      researchId: researchId,
    ));
  }
}
