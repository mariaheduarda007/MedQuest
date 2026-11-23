import 'question_entity.dart';

class QuestionMapper {
  static Map<String, dynamic> toMap(Question question) {
    return {
      if (question.alternatives.isNotEmpty)
        'alternatives': question.alternatives
            .map(
              (item) => {
                'choice': item['choice']?.toString() ?? '',
                'value': (item['value'] as num?)?.toDouble() ?? 0.0,
              },
            )
            .toList(),
      'text': question.text,
      'type': question.type,
      if (question.orientation != null &&
          question.orientation!.trim().isNotEmpty)
        'orientation': question.orientation!.trim(),
    };
  }

  static Question fromMap(Map<String, dynamic> map, {String? documentId}) {
    final id = documentId != null && documentId.isNotEmpty
        ? documentId
        : map['id']?.toString() ?? '';
    final rawAlternatives = map['alternatives'];

    return Question(
      id: id,
      alternatives: (rawAlternatives is Iterable ? rawAlternatives : const [])
          .whereType<Map>()
          .map((item) {
            final alternativeMap = Map<String, dynamic>.from(item);
            return {
              'choice': alternativeMap['choice']?.toString() ?? '',
              'value': (alternativeMap['value'] as num?)?.toDouble() ?? 0.0,
            };
          })
          .toList(),
      text: map['text']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      orientation: map['orientation']?.toString(),
    );
  }
}
