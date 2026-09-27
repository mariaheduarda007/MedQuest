import 'package:flutter/material.dart';

import 'package:medquest/research/presentation/widgets/main_card.dart';

class ResearchCard extends MainCard {
  ResearchCard({
    super.key,
    required super.title, // fornecido ao ser criado
    required this.participants,
    required this.groups,
    required this.researchers,
    required super.onTap,
  }) : super(
         icon: Icons.science, // fixos direto no maincard
         infoTexts: [
           'Participantes: $participants',
           'Grupos: $groups',
           'Pesquisadores: $researchers',
         ],
       );

  final int participants;
  final int groups;
  final int researchers;

}
