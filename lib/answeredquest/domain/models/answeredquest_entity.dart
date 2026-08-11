import 'package:equatable/equatable.dart';
import 'package:medquest/modelquest/domain/models/question_entity.dart';

class AnsweredQuest extends Equatable {
  final String id;
  final String idModelQuest;
  final List<Question> questions;

  const AnsweredQuest({required this.id, required this.idModelQuest, required this.questions});

  AnsweredQuest copyWith({String? id, String? idModelQuest, List<Question>? questions}) {
    return AnsweredQuest(
      id: id ?? this.id,
      idModelQuest: idModelQuest ?? this.idModelQuest,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [id, idModelQuest, questions];

  @override
  toString() => 'AnsweredQuest(id: $id, idModelQuest: $idModelQuest, questions: $questions)';
}
