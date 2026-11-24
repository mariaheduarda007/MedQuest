import 'package:equatable/equatable.dart';

class Research extends Equatable {
  final String id;
  final String name;
  final DateTime date;
  final List<String> quests;
  final Map<String, String> researchAttributes;
  final String interval;
  final bool archived;

  Research({
    this.id = '',
    this.name = 'Pesquisa Nova',
    DateTime? date,
    this.quests = const [],
    this.researchAttributes = const {},
    this.interval = '',
    this.archived = false,
  }) : date = date ?? DateTime.now();

  Research copyWith({
    String? id,
    String? name,
    DateTime? date,
    List<String>? quests,
    Map<String, String>? researchAttributes,
    String? interval,
    bool? archived,
  }) {
    return Research(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      quests: quests ?? this.quests,
      researchAttributes: researchAttributes ?? this.researchAttributes,
      interval: interval ?? this.interval,
      archived: archived ?? this.archived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    date,
    quests,
    researchAttributes,
    interval,
    archived,
  ];

  @override
  String toString() {
    return 'Research('
        'id: $id, '
        'name: $name, '
        'date: $date, '
        'quests: $quests, '
        'researchAttributes: $researchAttributes, '
        ')';
  }
}
