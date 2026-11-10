import 'package:medquest/answeredquest/domain/models/answeredquest_entity.dart';

class AnsweredQuestMapper {
  static Map<String, dynamic> toMap(AnsweredQuest answeredQuest) {
    return {'idModelQuest': answeredQuest.idModelQuest};
  }

  static AnsweredQuest fromMap(Map<String, dynamic> map, {String? documentId}) {
    return AnsweredQuest(
      id: documentId != null && documentId.isNotEmpty
          ? documentId
          : map['id']?.toString() ?? '',
      idModelQuest: map['idModelQuest']?.toString() ?? '',
      questions: const [],
    );
  }
}
