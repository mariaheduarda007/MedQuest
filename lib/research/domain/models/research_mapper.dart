import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResearchMapper {
  static Research fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Research(
      id: documentId!,
      name: map['name'],
      date: _dateTime(map['date']),
      quests: _stringList(map['quests']),
      researchAttributes: _stringMap(map['attributes']),
      archived: map['archived'] == true,
    );
  }

  static DateTime _dateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      final parsedDate = DateTime.tryParse(value);
      if (parsedDate != null) return parsedDate;
    }

    throw const FormatException('Data da pesquisa ausente ou inválida.');
  }

  static List<String> _stringList(Object? value) {
    if (value is! Iterable) return const [];

    return value
        .map((item) {
          if (item is DocumentReference) {
            return item.id;
          }
          return item;
        })
        .whereType<String>()
        .toList();
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is! Map) return const {};

    final result = <String, String>{};
    value.forEach((key, item) {
      if (key is String && item is String) {
        result[key] = item;
      }
    });
    return result;
  }

  static Map<String, dynamic> toMap(Research research) {
    return {
      'name': research.name,
      'date': research.date.toIso8601String(),
      'quests': research.quests,
      'attributes': research.researchAttributes,
      'archived': research.archived,
    };
  }
}
