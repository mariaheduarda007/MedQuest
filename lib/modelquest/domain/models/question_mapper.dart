
import 'question_entity.dart';

class QuestionMapper {
  static Map<String, dynamic> toMap(Question question) {
    return {
      'id': question.id,
      'alternatives': question.alternatives
          .map((item) => {
                'choice': item['choice']?.toString() ?? '',
                'value': (item['value'] as num?)?.toDouble() ?? 0.0,
              })
          .toList(),
      'text': question.text,
      'type': question.type,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id']?.toString() ?? '',
      alternatives: (map['alternatives'] as List<dynamic>? ?? [])
          .map((item) {
            final alternativeMap = item as Map<dynamic, dynamic>;
            return {
              'choice': alternativeMap['choice']?.toString() ?? '',
              'value': (alternativeMap['value'] as num?)?.toDouble() ?? 0.0,
            };
          })
          .toList(),
      text: map['text']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
    );
  }
}
