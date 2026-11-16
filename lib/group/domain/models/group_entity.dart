import 'package:equatable/equatable.dart';
import 'package:medquest/patient/domain/models/patient_entity.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final int patientCount;
  final List<Patient> patients;

  const Group({this.id = '', this.name = 'Grupo Novo', this.patientCount = 0, this.patients = const []});

  Group copyWith({String? id, String? name, int? patientCount, List<Patient>? patients}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      patientCount: patientCount ?? this.patientCount,
      patients: patients ?? this.patients,
    );
  }

  @override
  List<Object?> get props => [id, name, patientCount, patients];

  @override
  String toString() {
    return 'Group('
        'id: $id, name: $name, patientCount: $patientCount, patients: $patients)';
  }
}
