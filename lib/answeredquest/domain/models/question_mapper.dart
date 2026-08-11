
import 'question_entity.dart';

class QuestionMapper {
  static Map<String, dynamic> toMap(Question question) {
    return {
      'id': question.id,
      'idModelQuestion': question.idModelQuestion,
      'answer': question.answer,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id']?.toString() ?? '',
      idModelQuestion: map['idModelQuestion']?.toString() ?? '',
      answer: map['answer']?.toString() ?? '',
    );
  }
}

            

