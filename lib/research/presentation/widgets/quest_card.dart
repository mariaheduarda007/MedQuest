import 'package:flutter/material.dart';
import 'package:medquest/research/presentation/widgets/main_card.dart';


class QuestCard extends MainCard {
  QuestCard({
    super.key,
    required super.title,
    required this.creationDate,
    required this.questions,
    required super.onTap,
  }) : super(
          icon: Icons.edit_note_rounded,
          infoTexts:  [
            'Criado em: $creationDate',
            'Perguntas: $questions',
          ],
        );

  final String creationDate;
  final String questions;

  
}