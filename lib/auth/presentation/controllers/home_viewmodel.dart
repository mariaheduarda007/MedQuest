import 'package:medquest/modelquest/presentation/commands/modelquest_commands.dart';
import 'package:medquest/research/presentation/commands/research_commands.dart';
import 'package:medquest/userContext/userRole/presentation/commands/userRole_commands.dart';

import 'home_commands_viewmodel.dart';
import 'home_state_viewmodel.dart';

class HomeViewModel {
  final HomeStateViewModel homeState;
  final HomeCommandsViewModel commands;

  HomeViewModel({required this.homeState, required this.commands});

  GetResearchesCommand get getResearchesCommand =>
      commands.getResearchesCommand;

  GetAllModelQuestsCommand get getAllModelQuestsCommand =>
      commands.getAllModelQuestsCommand;

  GetUserRolesByUserIdCommand get getUserRolesByUserIdCommand =>
      commands.getUserRolesByUserIdCommand;
}
