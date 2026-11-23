import '../../../core/typedefs/type_defs.dart';
import 'answeredquest_repository_interface.dart';
import '../service/answeredquest_firestore_interface.dart';

/// implementação do repositório para AnsweredQuest

final class AnsweredQuestRepositoryImpl implements IAnsweredQuestRepository {
  final IAnsweredQuestFirestore _firestore;

  AnsweredQuestRepositoryImpl({required IAnsweredQuestFirestore firestore})
    : _firestore = firestore;

  @override
  Future<AnsweredQuestResult> createAnsweredQuest(
    CreateAnsweredQuestParams params,
  ) {
    return _firestore.createAnsweredQuest(params);
  }

  @override
  Future<AnsweredQuestResult> getAnsweredQuest(AnsweredQuestIdParams params) {
    return _firestore.getAnsweredQuest(params);
  }

  @override
  Future<AnsweredQuestsResult> getAnsweredQuests(PatientParams params) {
    return _firestore.getAnsweredQuests(params);
  }

  @override
  Future<AnsweredQuestResult> updateAnsweredQuest(AnsweredQuestParams params) {
    return _firestore.updateAnsweredQuest(params);
  }

  @override
  Future<VoidResult> deleteAnsweredQuest(AnsweredQuestIdParams params) {
    return _firestore.deleteAnsweredQuest(params);
  }
}
