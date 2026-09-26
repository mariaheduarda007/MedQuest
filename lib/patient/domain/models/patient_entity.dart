import 'package:equatable/equatable.dart';

enum SmokingLevel {
  never,
  former,
  occasional,
  daily;

  String get displayName {
    switch (this) {
      case SmokingLevel.never:
        return 'Nunca';
      case SmokingLevel.former:
        return 'Ex-fumante';
      case SmokingLevel.occasional:
        return 'Ocasional';
      case SmokingLevel.daily:
        return 'Diariamente';
     
    }
  }
}

class Patient extends Equatable {
  final String id;
  final String name;
  final int treatmentStartAge;
  final String sex;
  final double income;
  final SmokingLevel smokingLevel;
  final String elitism;
  final String ethnicity;
  final String birthPlacement;
  final DateTime birthDate;
  final double weight;
  final double height;
  final String occupation;
  final String educationLevel;
  final List<String> drugs;
  final List<String> comorbidities;
  final bool participationStatus;
  final String? exitReason;
  final Map<String, String> researchAttributes;

  const Patient({
    required this.id,
    required this.name,
    required this.treatmentStartAge,
    required this.sex,
    required this.income,
    required this.smokingLevel,
    required this.elitism,
    required this.ethnicity,
    required this.birthPlacement,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.occupation,
    required this.educationLevel,
    required this.drugs,
    required this.comorbidities,
    required this.participationStatus,
    this.exitReason,
    required this.researchAttributes,
  });

  Patient copyWith({
    String?id,
    String? name,
    int? treatmentStartAge,
    String? sex,
    double? income,
    SmokingLevel? smokingLevel,
    String? elitism,
    String? ethnicity,
    String? birthPlacement,
    DateTime? birthDate,
    double? weight,
    double? height,
    String? occupation,
    String? educationLevel,
    List<String>? drugs,
    List<String>? comorbidities,
    bool? participationStatus,
    String? exitReason,
    Map<String, String>? researchAttributes,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      treatmentStartAge: treatmentStartAge ?? this.treatmentStartAge,
      sex: sex ?? this.sex,
      income: income ?? this.income,
      smokingLevel: smokingLevel ?? this.smokingLevel,
      elitism: elitism ?? this.elitism,
      ethnicity: ethnicity ?? this.ethnicity,
      birthPlacement: birthPlacement ?? this.birthPlacement,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      occupation: occupation ?? this.occupation,
      educationLevel: educationLevel ?? this.educationLevel,
      drugs: drugs ?? this.drugs,
      comorbidities: comorbidities ?? this.comorbidities,
      participationStatus:
          participationStatus ?? this.participationStatus,
      exitReason: exitReason ?? this.exitReason,
      researchAttributes:
          researchAttributes ?? this.researchAttributes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        treatmentStartAge,
        sex,
        income,
        smokingLevel,
        elitism,
        ethnicity,
        birthPlacement,
        birthDate,
        weight,
        height,
        occupation,
        educationLevel,
        drugs,
        comorbidities,
        participationStatus,
        exitReason,
        researchAttributes,
      ];

  @override
  String toString() {
    return 'Patient('
        'id: $id, '
        'name: $name, '
        'treatmentStartAge: $treatmentStartAge, '
        'sex: $sex, '
        'income: $income, '
        'smokingLevel: ${smokingLevel.name}, '
        'elitism: $elitism, '
        'ethnicity: $ethnicity, '
        'birthPlacement: $birthPlacement, '
        'birthDate: $birthDate, '
        'weight: $weight, '
        'height: $height, '
        'occupation: $occupation, '
        'educationLevel: $educationLevel, '
        'drugs: $drugs, '
        'comorbidities: $comorbidities, '
        'participationStatus: $participationStatus, '
        'exitReason: $exitReason, '
        'researchAttributes: $researchAttributes'
        ')';
  }
}