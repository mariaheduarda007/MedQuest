import '../../../core/typedefs/type_defs.dart';

abstract interface class IAnsweredQuestFacadeUseCases {
  Future<AnsweredQuestResult> createAnsweredQuest(AnsweredQuestParams params);
  Future<AnsweredQuestResult> getAnsweredQuest(AnsweredQuestIdParams params);
  Future<AnsweredQuestsResult> getAnsweredQuests(PatientQuestsParams params);
  Future<AnsweredQuestResult> updateAnsweredQuest(AnsweredQuestParams params);
  Future<VoidResult> deleteAnsweredQuest(AnsweredQuestIdParams params);
}
