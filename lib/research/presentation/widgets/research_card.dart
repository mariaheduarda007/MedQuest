import 'package:flutter/material.dart';

import 'package:medquest/research/presentation/widgets/main_card.dart';

class ResearchCard extends MainCard {
  ResearchCard({
    super.key,
    required super.title,
    required this.date,
    required this.questionnaires,
    required super.onTap,
  }) : super(
         icon: Icons.science, // fixos direto no maincard
         infoTexts: ['Data: $date', 'Questionários: $questionnaires'],
       );

  final String date;
  final int questionnaires;
}
