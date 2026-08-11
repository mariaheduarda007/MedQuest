import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;  
  final String idModelQuestion;  
  final String answer;

  const Question({
    required this.id,
    required this.idModelQuestion,
    required this.answer,
  });

  Question copyWith({
    String? id,
    String? idModelQuestion,
    String? answer,
  }) {
    return Question(
      id: id ?? this.id,
      idModelQuestion: idModelQuestion ?? this.idModelQuestion, 
      answer: answer ?? this.answer,
    );
  }

  @override
  List<Object?> get props => [id, idModelQuestion, answer];

  @override
  String toString() {
    return 'Question(id: $id, idModelQuestion: $idModelQuestion, answer: $answer)';
  }
}
