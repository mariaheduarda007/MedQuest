import 'package:medquest/modelquest/presentation/controllers/modelquests_state_viewmodel.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/domain/facades/i_userRole_facade_usecases.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';
import 'package:medquest/userContext/userRole/presentation/commands/userRole_commands.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../domain/models/modelquest_entity.dart';
import '../commands/modelquest_commands.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ModelQuestsCommandsViewModel {
  final ModelQuestsStateViewModel state;
  //Administrador nao esta vinculado a pesquisa mas ve todos os modelquests, ou pode estar vinculado à todas
  final GetAllModelQuestsCommand _getAllModelQuestsCommand;
  final GetModelQuestsFromResearchCommand _getModelQuestsFromResearchCommand;
  final CreateModelQuestCommand _createModelQuestCommand;
  final GetUserRolesByUserIdCommand _getUserRolesByUserIdCommand;
  final PermissionCacheService _permissionCacheService;

  ModelQuestsCommandsViewModel({
    required this.state,
    required CreateModelQuestCommand createModelQuestCommand,
    required GetAllModelQuestsCommand getAllModelQuestsCommand,
    required GetModelQuestsFromResearchCommand
    getModelQuestsFromResearchCommand,
    required IUserRoleFacadeUseCases userRoleFacade,
    required PermissionCacheService permissionCacheService,
  }) : _createModelQuestCommand = createModelQuestCommand,
       _getAllModelQuestsCommand = getAllModelQuestsCommand,
       _getModelQuestsFromResearchCommand = getModelQuestsFromResearchCommand,
       _getUserRolesByUserIdCommand = GetUserRolesByUserIdCommand(
         userRoleFacade,
       ),
       _permissionCacheService = permissionCacheService {
    _observeCreateModelQuest();
    _observeGetAllModelQuests();
    _observeGetModelQuestsFromResearch();
    _observeGetUserRolesByUserId();
  }

  CreateModelQuestCommand get createModelQuestCommand =>
      _createModelQuestCommand;
  GetAllModelQuestsCommand get getAllModelQuestsCommand =>
      _getAllModelQuestsCommand;
  GetModelQuestsFromResearchCommand get getModelQuestsFromResearchCommand =>
      _getModelQuestsFromResearchCommand;
   GetUserRolesByUserIdCommand get getUserRolesByUserIdCommand =>
      _getUserRolesByUserIdCommand;

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

  void _observeCreateModelQuest() {
    _observeCommand<ModelQuest>(
      _createModelQuestCommand,
      onSuccess: (modelQuest) {
        state.modelQuestSuccessEvent.value = ModelQuestsSuccessEvent.created;
        state.setModelQuest(modelQuest);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetAllModelQuests() {
    _observeCommand<List<ModelQuest>>(
      _getAllModelQuestsCommand,
      onSuccess: (modelQuests) {
        state.setModelQuests(modelQuests);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetModelQuestsFromResearch() {
    _observeCommand<List<ModelQuest>>(
      _getModelQuestsFromResearchCommand,
      onSuccess: (modelQuests) {
        state.setModelQuests(modelQuests);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetUserRolesByUserId() {
    _observeCommand<List<UserRoleModel>>(
      _getUserRolesByUserIdCommand,
      onSuccess: (roles) {
        state.setCanCreateModelQuest(
          roles.any(
            (role) => _permissionCacheService.hasPermission(
              role.permissionId,
              'createModelQuest',
            ),
          ),
        );
        state.clearPermissionMessage();
      },
      onFailure: (failure) {
        state.setCanCreateModelQuest(false);
        state.setPermissionMessage(failure.msg);
      },
    );
  }

  Future<void> createModelQuest(ModelQuest modelQuest) async {
    await _createModelQuestCommand.executeWith((modelQuest: modelQuest));
  }

  Future<void> getAllModelQuests() async {
    await _getAllModelQuestsCommand.executeWith(());
  }

  Future<void> getModelQuestsFromResearch(String researchId) async {
    await _getModelQuestsFromResearchCommand.executeWith((
      researchId: researchId,
    ));
  }

  Future<void> loadUserPermissions(String userId) async {
    state.setLoadingPermissions(true);
    state.clearPermissionMessage();
    state.setCanCreateModelQuest(false);

    try {
      await _permissionCacheService.loadPermissions();
      await _getUserRolesByUserIdCommand.executeWith((userId: userId));
    } on Exception catch (error) {
      state.setPermissionMessage(
        'Não foi possível carregar as permissões: $error',
      );
    } finally {
      state.setLoadingPermissions(false);
    }
  }
}
