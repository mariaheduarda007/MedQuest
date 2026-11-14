import 'package:flutter/material.dart';
import 'package:medquest/research/presentation/widgets/main_card.dart';


class GroupCard extends MainCard {
  GroupCard({
    super.key,
    required super.title,
    required this.patients,
    required super.onTap,
  }) : super(
          icon: Icons.edit_note_rounded,
          infoTexts:  [
            'Pacientes: $patients',
          ],
        );

  final String patients;

  
}