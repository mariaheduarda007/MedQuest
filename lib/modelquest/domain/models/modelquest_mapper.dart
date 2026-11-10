import 'modelquest_entity.dart';

class ModelQuestMapper {
  static Map<String, dynamic> toMap(ModelQuest modelQuest) {
    return {
      'name': modelQuest.name,
      
    };
  } 

  static ModelQuest fromMap(
    Map<String, dynamic> map, {
    String? documentId,
    
  }) {
    // final List<Question> questions;
    // final rawQuestions = map['questions'];
    // if (rawQuestions is Iterable) {
    //   questions = rawQuestions
    //       .whereType<Map>()
    //       .map(
    //         (question) => QuestionMapper.fromMap(
    //           Map<String, dynamic>.from(question),
    //           documentId: question['id']?.toString(),
    //         ),
    //       )
    //       .toList();
    // } else {
    //   questions = const [];
    // }

    final id = documentId != null && documentId.isNotEmpty
        ? documentId
        : map['id']?.toString() ?? '';
    final rawName = map['name'];
    return ModelQuest(
      id: id,
      name: rawName is String && rawName.isNotEmpty
          ? rawName
          : 'Questionário sem nome',
    );
  }
}
