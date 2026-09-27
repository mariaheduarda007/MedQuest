import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';
import 'main_card.dart';

class CardCarousel extends StatelessWidget {
  const CardCarousel({super.key, required this.cards, required this.title});

  final List<MainCard> cards;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      // color: const Color.fromARGB(255, 126, 206, 144),
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.horizontalMd,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.headlineLarge
                  ?.withColor(const Color(0xFF2C0E2C))
                  .semiBold,
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: cards.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: AppSpacing.sm);
              },
              itemBuilder: (context, index) {
                final card = cards[index];
                return MainCard(
                  title: card.title,
                  icon: card.icon,
                  infoTexts: card.infoTexts,
                  onTap: () {
                    // Ação ao pressionar o card
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
