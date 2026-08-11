import 'package:medquest/answeredquest/domain/facade/answeredquest_facade_usecases_interface.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/command.dart';
import '../../../core/patterns/result.dart';
import '../../../core/typedefs/type_defs.dart';
import '../../domain/models/answeredquest_entity.dart';

final class CreateAnsweredQuestCommand
    extends ParameterizedCommand<AnsweredQuest, Failure, AnsweredQuestParams> {
  final IAnsweredQuestFacadeUseCases _answeredQuestFacadeUseCases;

  CreateAnsweredQuestCommand(this._answeredQuestFacadeUseCases);

  @override
  Future<AnsweredQuestResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para criar answered quest.'));
    }

    return await _answeredQuestFacadeUseCases.createAnsweredQuest(parameter!);
  }
}

final class GetAnsweredQuestCommand
    extends
        ParameterizedCommand<AnsweredQuest, Failure, AnsweredQuestIdParams> {
  final IAnsweredQuestFacadeUseCases _answeredQuestFacadeUseCases;

  GetAnsweredQuestCommand(this._answeredQuestFacadeUseCases);

  @override
  Future<AnsweredQuestResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar answered quest.'));
    }
    return await _answeredQuestFacadeUseCases.getAnsweredQuest(parameter!);
  }
}

final class GetAnsweredQuestsCommand
    extends
        ParameterizedCommand<
          List<AnsweredQuest>,
          Failure,
          PatientQuestsParams
        > {
  final IAnsweredQuestFacadeUseCases _answeredQuestFacadeUseCases;

  GetAnsweredQuestsCommand(this._answeredQuestFacadeUseCases);

  @override
  Future<AnsweredQuestsResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para buscar answered quests.'));
    }
    return await _answeredQuestFacadeUseCases.getAnsweredQuests(parameter!);
  }
}

final class UpdateAnsweredQuestCommand
    extends ParameterizedCommand<AnsweredQuest, Failure, AnsweredQuestParams> {
  final IAnsweredQuestFacadeUseCases _answeredQuestFacadeUseCases;

  UpdateAnsweredQuestCommand(this._answeredQuestFacadeUseCases);

  @override
  Future<AnsweredQuestResult> execute() async {
    if (parameter == null) {
      return Error(
        InputFailure('Parametro nulo para atualizar answered quest.'),
      );
    }
    return await _answeredQuestFacadeUseCases.updateAnsweredQuest(parameter!);
  }
}

final class DeleteAnsweredQuestCommand
    extends ParameterizedCommand<void, Failure, AnsweredQuestIdParams> {
  final IAnsweredQuestFacadeUseCases _answeredQuestFacadeUseCases;

  DeleteAnsweredQuestCommand(this._answeredQuestFacadeUseCases);

  @override
  Future<VoidResult> execute() async {
    if (parameter == null) {
      return Error(InputFailure('Parametro nulo para excluir answered quest.'));
    }
    return await _answeredQuestFacadeUseCases.deleteAnsweredQuest(parameter!);
  }
}
