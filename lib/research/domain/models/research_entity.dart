import 'package:equatable/equatable.dart';

class Research extends Equatable {
  final String id;
  final String name;
  final DateTime date;
  final List<String> quests;
  final Map<String, String> researchAttributes;

  const Research({
    required this.id,
    required this.name,
    required this.date,
    required this.quests,
    required this.researchAttributes,
  });

  Research copyWith({
    String?id,
    String? name,
    DateTime? date,
    List<String>? quests,
    Map<String, String>? researchAttributes,
  }) {
    return Research(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      quests: quests ?? this.quests,
      researchAttributes: researchAttributes ?? this.researchAttributes,
    );
  }

  @override
  List<Object?> get props => [id, name, date, quests, researchAttributes];

  @override
String toString() {
  return 'Research('
      'id: $id, '
      'name: $name, '
      'date: $date, '
      'quests: $quests, '
      'researchAttributes: $researchAttributes'
      ')';
}
}


