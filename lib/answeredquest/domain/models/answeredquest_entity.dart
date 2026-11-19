import 'package:equatable/equatable.dart';
import 'package:medquest/answeredquest/domain/models/question_entity.dart';

class AnsweredQuest extends Equatable {
  final String id;
  final String idModelQuest;
  final List<Question> questions;
  final String name;

  const AnsweredQuest({this.id = '', required this.idModelQuest, required this.questions, required this.name});

  AnsweredQuest copyWith({String? id, String? idModelQuest, List<Question>? questions, String? name}) {
    return AnsweredQuest(
      id: id ?? this.id,
      idModelQuest: idModelQuest ?? this.idModelQuest,
      questions: questions ?? this.questions,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, idModelQuest, questions, name];

  @override
  toString() => 'AnsweredQuest(id: $id, idModelQuest: $idModelQuest, questions: $questions, name: $name)';
}
