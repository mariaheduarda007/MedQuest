import 'package:medquest/answeredquest/domain/facade/answeredquest_facade_usecases_interface.dart';
import '../../../core/typedefs/type_defs.dart';
import '../usecases/answeredquest_usecases_interface.dart';

final class AnsweredQuestFacadeUsecasesImpl
    implements IAnsweredQuestFacadeUseCases {
  final ICreateAnsweredQuestUseCase _createAnsweredQuestUseCase;
  final IGetAnsweredQuestUseCase _getAnsweredQuestUseCase;
  final IGetAnsweredQuestsUseCase _getAnsweredQuestsUseCase;
  final IUpdateAnsweredQuestUseCase _updateAnsweredQuestUseCase;
  final IDeleteAnsweredQuestUseCase _deleteAnsweredQuestUseCase;

  AnsweredQuestFacadeUsecasesImpl({
    required ICreateAnsweredQuestUseCase createAnsweredQuestUseCase,
    required IGetAnsweredQuestUseCase getAnsweredQuestUseCase,
    required IGetAnsweredQuestsUseCase getAnsweredQuestsUseCase,
    required IUpdateAnsweredQuestUseCase updateAnsweredQuestUseCase,
    required IDeleteAnsweredQuestUseCase deleteAnsweredQuestUseCase,
  }) : _createAnsweredQuestUseCase = createAnsweredQuestUseCase,
       _getAnsweredQuestUseCase = getAnsweredQuestUseCase,
       _getAnsweredQuestsUseCase = getAnsweredQuestsUseCase,
       _updateAnsweredQuestUseCase = updateAnsweredQuestUseCase,
       _deleteAnsweredQuestUseCase = deleteAnsweredQuestUseCase;

  @override
  Future<AnsweredQuestResult> createAnsweredQuest(AnsweredQuestParams params) {
    return _createAnsweredQuestUseCase(params);
  }

  @override
  Future<AnsweredQuestResult> getAnsweredQuest(AnsweredQuestIdParams params) {
    return _getAnsweredQuestUseCase(params);
  }

  @override
  Future<AnsweredQuestsResult> getAnsweredQuests(PatientQuestsParams params) {
    return _getAnsweredQuestsUseCase(params);
  }

  @override
  Future<AnsweredQuestResult> updateAnsweredQuest(AnsweredQuestParams params) {
    return _updateAnsweredQuestUseCase(params);
  }

  @override
  Future<VoidResult> deleteAnsweredQuest(AnsweredQuestIdParams params) {
    return _deleteAnsweredQuestUseCase(params);
  }
}
