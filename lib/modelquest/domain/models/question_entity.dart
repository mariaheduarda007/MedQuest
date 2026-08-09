import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;  
  final List<Map<String, dynamic>> alternatives;
  final String text;
  final String type;

  const Question({
    required this.id,
    required this.alternatives,
    required this.text,
    required this.type,
  });

  Question copyWith({
    String? id,
    List<Map<String, dynamic>>? alternatives,
    String? text,
    String? type,
  }) {
    return Question(
      id: id ?? this.id,
      alternatives: alternatives ?? this.alternatives,
      text: text ?? this.text,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, alternatives, text, type];

  @override
  String toString() {
    return 'Question(id: $id, alternatives: $alternatives, text: $text, type: $type)';
  }
}
