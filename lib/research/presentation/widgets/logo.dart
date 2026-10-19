
import 'package:flutter/material.dart';

class MedQuestLogo extends StatelessWidget {
  const MedQuestLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/core/theme/assets/logo.png',
      width: 250,
      height: 80,
      fit: BoxFit.fitWidth,
    );
  }
}
