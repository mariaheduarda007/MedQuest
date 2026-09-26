import 'dart:core';
import 'package:equatable/equatable.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';

class ModelQuest extends Equatable {
  final String id;
  final String name;
  final List<Question> questions;

  const ModelQuest({required this.id, required this.name, required this.questions});

  ModelQuest copyWith({String? id, String? name, List<Question>? questions}) {
    return ModelQuest(
      id: id ?? this.id,
      name: name ?? this.name,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [id, name, questions];

  @override
  String toString() {
    return 'Model Quest('
        'id: $id, '
        'name: $name, '
        'questions: $questions'
        ')';
  }
}
