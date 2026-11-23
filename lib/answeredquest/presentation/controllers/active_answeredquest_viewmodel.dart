import 'package:medquest/answeredquest/presentation/commands/answeredquest_commands.dart';
import 'answeredquest_commands_viewmodel.dart';
import 'answeredquest_state_viewmodel.dart';

class AnsweredQuestViewModel {
  late final AnsweredQuestStateViewModel _state;

  AnsweredQuestStateViewModel get answeredQuestState => _state;

  late final AnsweredQuestCommandsViewModel commands;

  AnsweredQuestViewModel({
    required AnsweredQuestStateViewModel state,
    required this.commands,
  }) : _state = state;

  CreateAnsweredQuestCommand get createAnsweredQuestCommand => commands.createAnsweredQuestCommand;
  GetAnsweredQuestCommand get getAnsweredQuestCommand => commands.getAnsweredQuestCommand;
  GetAnsweredQuestsCommand get getAnsweredQuestsCommand => commands.getAnsweredQuestsCommand;
  UpdateAnsweredQuestCommand get updateAnsweredQuestCommand => commands.updateAnsweredQuestCommand;
  DeleteAnsweredQuestCommand get deleteAnsweredQuestCommand => commands.deleteAnsweredQuestCommand;

}
