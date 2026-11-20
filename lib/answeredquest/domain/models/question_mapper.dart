import 'question_entity.dart';

class QuestionMapper {
  static Map<String, dynamic> toMap(Question question) {
    return {
      'idModelQuestion': question.idModelQuestion,
      'answer': question.answer,
      'score': question.score,
    };
  }

  static Question fromMap(Map<String, dynamic> map, {String? documentId}) {
    final id = documentId != null && documentId.isNotEmpty
        ? documentId
        : map['id']?.toString() ?? '';
    return Question(
      id: id,
      idModelQuestion: map['idModelQuestion']?.toString() ?? '',
      answer: map['answer']?.toString() ?? '',
      score: map['score'] != null ? num.tryParse(map['score'].toString()) : null,
    );
  }
}

            

