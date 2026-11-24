import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/command.dart';
import 'package:medquest/core/patterns/result.dart';
import 'package:medquest/modelquest/domain/facade/modelquest_facade_usecases_interface.dart';
import 'package:medquest/modelquest/domain/models/modelquest_entity.dart';
import 'package:medquest/modelquest/presentation/commands/modelquest_commands.dart';
import 'package:medquest/research/domain/facade/research_facade_usecases_interface.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/presentation/commands/research_commands.dart';
import 'package:medquest/userContext/permission/data/services/remote/permission_cache_service.dart';
import 'package:medquest/userContext/userRole/domain/facades/i_userRole_facade_usecases.dart';
import 'package:medquest/userContext/userRole/domain/models/userRole_model.dart';
import 'package:medquest/userContext/userRole/presentation/commands/userRole_commands.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'home_state_viewmodel.dart';

class HomeCommandsViewModel {
  final HomeStateViewModel state;
  final GetResearchesCommand _getResearchesCommand;
  final CreateResearchCommand _createResearchCommand;
  final GetAllModelQuestsCommand _getAllModelQuestsCommand;
  final GetUserRolesByUserIdCommand _getUserRolesByUserIdCommand;
  final PermissionCacheService _permissionCacheService;

  HomeCommandsViewModel({
    required this.state,
    required IResearchFacadeUseCases researchFacade,
    required IModelQuestFacadeUseCases modelQuestFacade,
    required IUserRoleFacadeUseCases userRoleFacade,
    required PermissionCacheService permissionCacheService,
  }) : _getResearchesCommand = GetResearchesCommand(researchFacade),
       _createResearchCommand = CreateResearchCommand(researchFacade),
       _getAllModelQuestsCommand = GetAllModelQuestsCommand(modelQuestFacade),
       _getUserRolesByUserIdCommand = GetUserRolesByUserIdCommand(
         userRoleFacade,
       ),
       _permissionCacheService = permissionCacheService {
    _observeGetResearches();
    _observeCreateResearch();
    _observeGetAllModelQuests();
    _observeGetUserRolesByUserId();
  }

  GetResearchesCommand get getResearchesCommand => _getResearchesCommand;

  CreateResearchCommand get createResearchCommand => _createResearchCommand;

  GetAllModelQuestsCommand get getAllModelQuestsCommand =>
      _getAllModelQuestsCommand;

  GetUserRolesByUserIdCommand get getUserRolesByUserIdCommand =>
      _getUserRolesByUserIdCommand;

  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onFailure,
  }) {
    effect(() {
      if (command.isExecuting.value) return;

      final result = command.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (data) {
          onSuccess(data);
          command.clear();
        },
        onFailure: (failure) {
          onFailure(failure);
          command.clear();
        },
      );
    });
  }

  void _observeGetResearches() {
    _observeCommand<List<Research>>(
      _getResearchesCommand,
      onSuccess: (researches) {
        state.setResearches(researches);
        state.clearResearchesMessage();
      },
      onFailure: (failure) => state.setResearchesMessage(failure.msg),
    );
  }

  void _observeCreateResearch() {
    _observeCommand<Research>(
      _createResearchCommand,
      onSuccess: (research) {
        state.setResearches([research, ...state.researchesState.value]);
        state.clearResearchesMessage();
      },
      onFailure: (failure) => state.setResearchesMessage(failure.msg),
    );
  }

  void _observeGetAllModelQuests() {
    _observeCommand<List<ModelQuest>>(
      _getAllModelQuestsCommand,
      onSuccess: (modelQuests) {
        state.setModelQuests(modelQuests);
        state.clearModelQuestsMessage();
      },
      onFailure: (failure) => state.setModelQuestsMessage(failure.msg),
    );
  }

  void _observeGetUserRolesByUserId() {
    _observeCommand<List<UserRoleModel>>(
      _getUserRolesByUserIdCommand,
      onSuccess: (roles) {
        state.setCanCreateResearch(
          roles.any(
            (role) => _permissionCacheService.hasPermission(
              role.permissionId,
              'createResearch',
            ),
          ),
        );
        state.clearPermissionMessage();
      },
      onFailure: (failure) {
        state.setCanCreateResearch(false);
        state.setPermissionMessage(failure.msg);
      },
    );
  }

  Future<void> getResearches(String userId) async {
    state.clearResearchesMessage();

    final rolesResult = await _getUserRolesByUserIdCommand.executeWith((
      userId: userId,
    ));

    if (rolesResult.isFailure) {
      state.setResearchesMessage(rolesResult.failureValueOrNull!.msg);
      return;
    }

    final roles = rolesResult.successValueOrNull!;
    final isAdmin = roles.any((role) {
      final roleName =
          _permissionCacheService
              .allPermissions?[role.permissionId]?['roleName']
              ?.toString()
              .toLowerCase() ??
          '';
      return roleName == 'administrator';
    });

    final researchIds = isAdmin
        ? <String>[]
        : roles
              .map((role) => role.researchId)
              .whereType<String>()
              .map((id) => id.trim())
              .where((id) => id.isNotEmpty)
              .toSet()
              .toList();

    if (!isAdmin && researchIds.isEmpty) {
      state.setResearches([]);
      state.setResearchesMessage('Nenhuma pesquisa vinculada aos seus papéis.');
      return;
    }

    await _getResearchesCommand.executeWith((researchesId: researchIds));
  }

  Future<Result<Research, Failure>> createResearch(Research research) {
    return _createResearchCommand.executeWith((research: research));
  }

  Future<void> getAllModelQuests() async {
    state.clearModelQuestsMessage();
    await _getAllModelQuestsCommand.executeWith(());
  }

  Future<void> loadUserPermissions(String userId) async {
    state.setLoadingPermissions(true);
    state.clearPermissionMessage();
    state.setCanCreateResearch(false);

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

  Future<void> loadHome(String userId) async {
    await loadUserPermissions(userId);
    await Future.wait([getResearches(userId), getAllModelQuests()]);
  }
}
