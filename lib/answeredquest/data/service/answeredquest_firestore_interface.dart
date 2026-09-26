import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';
import '../../../core/typedefs/type_defs.dart';

abstract interface class IAnsweredQuestFirestore {
  Future<AnsweredQuestResult> createAnsweredQuest(AnsweredQuest answeredQuest);
  Future<AnsweredQuestResult> getAnsweredQuest(String answeredQuestId);
  Future<AnsweredQuestsResult> getAnsweredQuests(String patientId);
  Future<AnsweredQuestResult> updateAnsweredQuest(AnsweredQuest answeredQuest);
  Future<VoidResult> deleteAnsweredQuest(String answeredQuestId);
}
