import 'package:cloud_firestore/cloud_firestore.dart';

import 'patient_entity.dart';

class PatientMapper {
  static Map<String, dynamic> toMap(Patient patient) {
    return {
      'name': patient.name,
      'treatmentStartAge': patient.treatmentStartAge,
      'sex': patient.sex,
      'income': patient.income,
      'smokingLevel': patient.smokingLevel.name,
      'elitism': patient.elitism,
      'ethnicity': patient.ethnicity,
      'birthPlacement': patient.birthPlacement,
      'birthDate': patient.birthDate.toIso8601String(),
      'weight': patient.weight,
      'height': patient.height,
      'occupation': patient.occupation,
      'educationLevel': patient.educationLevel,
      'drugs': patient.drugs,
      'comorbidities': patient.comorbidities,
      'participationStatus': patient.participationStatus,
      'exitReason': patient.exitReason,
      'researchAttributes': patient.researchAttributes,
    };
  }

  static Patient fromMap(Map<String, dynamic> map, {String? documentId}) {
    return Patient(
      id: documentId ?? _stringValue(map['id'], 'id', fallback: ''),
      name: _stringValue(map['name'], 'name'),
      treatmentStartAge: _parseInt(map['treatmentStartAge']),
      sex: _stringValue(map['sex'], 'sex'),
      income: _parseDouble(map['income']),
      smokingLevel: SmokingLevel.values.byName(
        _stringValue(map['smokingLevel'], 'smokingLevel'),
      ),
      elitism: _stringValue(map['elitism'], 'elitism'),
      ethnicity: _stringValue(map['ethnicity'], 'ethnicity'),
      birthPlacement: _stringValue(map['birthPlacement'], 'birthPlacement'),
      birthDate: _parseDate(map['birthDate']),
      weight: _parseDouble(map['weight']),
      height: _parseDouble(map['height']),
      occupation: _stringValue(map['occupation'], 'occupation'),
      educationLevel: _stringValue(map['educationLevel'], 'educationLevel'),
      drugs: _stringList(map['drugs'], 'drugs'),
      comorbidities: _stringList(map['comorbidities'], 'comorbidities'),
      participationStatus: _parseBool(map['participationStatus']),
      exitReason: map['exitReason'] == null
          ? null
          : _stringValue(map['exitReason'], 'exitReason'),
      researchAttributes: _stringMap(map['researchAttributes']),
    );
  }

  static String _stringValue(dynamic value, String field, {String? fallback}) {
    if (value is String) return value;
    if (value is bool || value is num) return value.toString();
    if (value == null && fallback != null) return fallback;
    throw FormatException('Valor inválido para $field: $value');
  }

  static List<String> _stringList(dynamic value, String field) {
    if (value is! Iterable) {
      throw FormatException('Valor inválido para $field: $value');
    }

    return value.map((item) => _stringValue(item, '$field[]')).toList();
  }

  static Map<String, String> _stringMap(dynamic value) {
    if (value is! Map) {
      throw FormatException('Valor inválido para researchAttributes: $value');
    }

    return value.map(
      (key, item) => MapEntry(
        _stringValue(key, 'researchAttributes key'),
        _stringValue(item, 'researchAttributes value'),
      ),
    );
  }

   static DateTime _parseDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      final parsedDate = DateTime.tryParse(value);
      if (parsedDate != null) return parsedDate;
    }

    throw const FormatException('Data da pesquisa ausente ou inválida.');
  }
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Valor inválido para int: $value');
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Valor inválido para double: $value');
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }

    throw FormatException('Valor inválido para bool: $value');
  }
}
