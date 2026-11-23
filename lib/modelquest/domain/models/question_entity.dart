import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final List<Map<String, dynamic>> alternatives;
  final String text;
  final String type;
  final String? orientation;

  const Question({
    this.id = '',
    this.alternatives = const [],
    required this.text,
    required this.type,
    this.orientation,
  });

  Question copyWith({
    String? id,
    List<Map<String, dynamic>>? alternatives,
    String? text,
    String? type,
    String? orientation,
  }) {
    return Question(
      id: id ?? this.id,
      alternatives: alternatives ?? this.alternatives,
      text: text ?? this.text,
      type: type ?? this.type,
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  List<Object?> get props => [id, alternatives, text, type, orientation];

  @override
  String toString() {
    return 'Question(id: $id, alternatives: $alternatives, text: $text, type: $type, orientation: $orientation)';
  }
}
