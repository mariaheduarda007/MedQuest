import 'package:intl/intl.dart';
import 'package:medquest/research/domain/models/research_entity.dart';

class ResearchMapper {
  static Research fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    final id = _stringValue(map['id']) ?? documentId;
    final name = _stringValue(map['name']);
    if (id == null || id.isEmpty) {
      throw const FormatException('Pesquisa sem um ID válido.');
    }
    if (name == null || name.isEmpty) {
      throw FormatException('Pesquisa $id sem um nome válido.');
    }

    return Research(
      id: id,
      name: name,
      date: _dateValue(map['date']),
      quests: _stringList(map['quests']),
      researchAttributes: _stringMap(map['attributes']),
    );
  }

  static String? _stringValue(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static DateTime _dateValue(Object? value) {
    if (value is DateTime) return value;
    if (value is String) {
      final isoDate = DateTime.tryParse(value);
      if (isoDate != null) return isoDate;

      for (final pattern in ['dd/MM/yyyy', 'dd/MM/yy']) {
        try {
          return DateFormat(pattern).parseStrict(value);
        } on FormatException {
          continue;
        }
      }
    }

    throw const FormatException('Pesquisa sem uma data válida.');
  }

  static List<String> _stringList(Object? value) {
    if (value is! Iterable) return const [];
    return value.whereType<String>().toList();
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
      'id': research.id,
      'name': research.name,
      'date': research.date.toIso8601String(),
      'quests': research.quests,
      'attributes': research.researchAttributes,
    };
  }
}
