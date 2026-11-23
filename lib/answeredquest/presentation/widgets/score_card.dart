import 'package:material_ui/material_ui.dart';

class ResearcherScoreCard extends StatelessWidget {
  final num score;
  final String researcher;

  const ResearcherScoreCard({
    super.key,
    required this.score,
    required this.researcher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 205,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pontuação',
                style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
              ),
              Text(
                score.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pesquisador',
                style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
              ),
              Text(researcher, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
