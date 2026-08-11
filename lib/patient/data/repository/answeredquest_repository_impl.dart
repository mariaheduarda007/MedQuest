import '../../../core/typedefs/type_defs.dart';
import 'answeredquest_repository_interface.dart';
import '../service/answeredquest_firestore_interface.dart';
import '../../../answeredquest/domain/models/answeredquest_entity.dart';

/// implementação do repositório para AnsweredQuest

final class AnsweredQuestRepositoryImpl implements IAnsweredQuestRepository {
  final IAnsweredQuestFirestore _firestore;

  AnsweredQuestRepositoryImpl({required IAnsweredQuestFirestore firestore})
    : _firestore = firestore;

  @override
  Future<AnsweredQuestResult> createAnsweredQuest(AnsweredQuest answeredQuest) {
    return _firestore.createAnsweredQuest(answeredQuest);
  }

  @override
  Future<AnsweredQuestResult> getAnsweredQuest(String answeredQuestId) {
    return _firestore.getAnsweredQuest(answeredQuestId);
  }

  @override
  Future<AnsweredQuestsResult> getAnsweredQuests(String patientId) {
    return _firestore.getAnsweredQuests(patientId);
  }

  @override
  Future<AnsweredQuestResult> updateAnsweredQuest(AnsweredQuest answeredQuest) {
    return _firestore.updateAnsweredQuest(answeredQuest);
  }

  @override
  Future<VoidResult> deleteAnsweredQuest(String answeredQuestId) {
    return _firestore.deleteAnsweredQuest(answeredQuestId);
  }
}
