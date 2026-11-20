import 'package:medquest/modelquest/presentation/controllers/modelquests_commands_viewmodel.dart';
import 'package:medquest/modelquest/presentation/controllers/modelquests_state_viewmodel.dart';
import 'package:medquest/userContext/userRole/presentation/commands/userRole_commands.dart';
import '../commands/modelquest_commands.dart';

class ModelQuestsViewModel {
  late final ModelQuestsStateViewModel _state;

  ModelQuestsStateViewModel get modelQuestsState => _state;

  late final ModelQuestsCommandsViewModel commands;

  ModelQuestsViewModel({
    required ModelQuestsStateViewModel state,
    required this.commands,
  }) : _state = state;

  CreateModelQuestCommand get createModelQuestCommand =>
      commands.createModelQuestCommand;
  GetAllModelQuestsCommand get getAllModelQuestsCommand =>
      commands.getAllModelQuestsCommand;
  GetModelQuestsFromResearchCommand get getModelQuestsFromResearchCommand =>
      commands.getModelQuestsFromResearchCommand;

  GetUserRolesByUserIdCommand get getUserRolesByUserIdCommand =>
      commands.getUserRolesByUserIdCommand;
}
