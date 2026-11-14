import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final int patientCount;

  const Group({this.id = '', this.name = 'Grupo Novo', this.patientCount = 0});

  Group copyWith({String? id, String? name, int? patientCount}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      patientCount: patientCount ?? this.patientCount,
    );
  }

  @override
  List<Object?> get props => [id, name, patientCount];

  @override
  String toString() {
    return 'Group('
        'id: $id, name: $name, patientCount: $patientCount)';
  }
}
