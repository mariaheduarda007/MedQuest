import 'patient_entity.dart';

class PatientMapper {
  static Map<String, dynamic> toMap(Patient patient) {
    return {
      'id': patient.id,
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

  static Patient fromMap(Map<String, dynamic> map) {
  return Patient(
    id: map['id'] as String,
    name: map['name'] as String,
    treatmentStartAge: map['treatmentStartAge'] as int,
    sex: map['sex'] as String,
    income: (map['income'] as num).toDouble(),
    smokingLevel: SmokingLevel.values.byName(
      map['smokingLevel'] as String,
    ),
    elitism: map['elitism'] as String,
    ethnicity: map['ethnicity'] as String,
    birthPlacement: map['birthPlacement'] as String,
    birthDate: DateTime.parse(map['birthDate'] as String),
    weight: (map['weight'] as num).toDouble(),
    height: (map['height'] as num).toDouble(),
    occupation: map['occupation'] as String,
    educationLevel: map['educationLevel'] as String,
    drugs: List<String>.from(map['drugs'] as List),
    comorbidities: List<String>.from(map['comorbidities'] as List),
    participationStatus: map['participationStatus'] as bool,
    exitReason: map['exitReason'] as String?,
    researchAttributes: Map<String, String>.from(
      map['researchAttributes'] as Map,
    ),
  );
}
}
