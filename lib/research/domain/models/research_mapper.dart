import 'package:medquest/research/domain/models/research_entity.dart';

class ResearchMapper {
  static Research fromMap(Map<String, dynamic> map) {
    return Research(
      id: map['id'] as String,
      name: map['name'] as String,
      date: DateTime.parse(map['date']!), // data como string no map
      quests: List<String>.from(map['quests'] as List),
      researchAttributes: Map<String, String>.from(
        map['attributes'] as Map<String, String>,
      ),
    );
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
