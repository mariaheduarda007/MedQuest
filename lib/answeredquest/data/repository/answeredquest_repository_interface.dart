import '../../../core/typedefs/type_defs.dart';

abstract interface class IAnsweredQuestRepository {
  Future<AnsweredQuestResult> createAnsweredQuest(AnsweredQuestParams params);
  Future<AnsweredQuestResult> getAnsweredQuest(AnsweredQuestIdParams params);
  Future<AnsweredQuestsResult> getAnsweredQuests(PatientParams params);
  Future<AnsweredQuestResult> updateAnsweredQuest(AnsweredQuestParams params);
  Future<VoidResult> deleteAnsweredQuest(AnsweredQuestIdParams params);
}
