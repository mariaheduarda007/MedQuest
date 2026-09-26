import '../commands/modelquest_commands.dart';
import 'modelquest_commands_viewmodel.dart';
import 'modelquest_state_viewmodel.dart';

class ModelQuestViewModel {
  late final ModelQuestStateViewModel _state;

  ModelQuestStateViewModel get modelQuestState => _state;

  late final ModelQuestCommandsViewModel commands;

  ModelQuestViewModel({
    required ModelQuestStateViewModel state,
    required this.commands,
  }) : _state = state;

  CreateModelQuestCommand get createModelQuestCommand => commands.createModelQuestCommand;
  GetModelQuestCommand get getModelQuestCommand => commands.getModelQuestCommand;
  GetAllModelQuestsCommand get getAllModelQuestsCommand => commands.getAllModelQuestsCommand;
  GetModelQuestsFromResearchCommand get getModelQuestsFromResearchCommand => commands.getModelQuestsFromResearchCommand;
  UpdateModelQuestCommand get updateModelQuestCommand => commands.updateModelQuestCommand;
  DeleteModelQuestCommand get deleteModelQuestCommand => commands.deleteModelQuestCommand;
  CreateQuestionCommand get createQuestionCommand => commands.createQuestionCommand;
  UpdateQuestionCommand get updateQuestionCommand => commands.updateQuestionCommand;
  DeleteQuestionCommand get deleteQuestionCommand => commands.deleteQuestionCommand;
}
