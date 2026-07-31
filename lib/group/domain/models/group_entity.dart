import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;

  const Group({required this.id, required this.name});

  Group copyWith({String? id, String? name}) {
    return Group(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() {
    return 'Group('
        'id: $id, name: $name)';
  }
}
