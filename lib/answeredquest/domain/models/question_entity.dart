import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;  
  final String idModelQuestion;  
  final String? answer;
  final num? score;

  const Question({
    this.id = '',
    required this.idModelQuestion,
    required this.answer,
    this.score,
  });

  Question copyWith({
    String? id,
    String? idModelQuestion,
    String? answer,
    num? score,
  }) {
    return Question(
      id: id ?? this.id,
      idModelQuestion: idModelQuestion ?? this.idModelQuestion, 
      answer: answer ?? this.answer,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [id, idModelQuestion, answer, score];

  @override
  String toString() {
    return 'Question(id: $id, idModelQuestion: $idModelQuestion, answer: $answer, score: $score)';
  }
}
