import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';
import 'package:medquest/research/presentation/widgets/action_button.dart';
import 'package:medquest/research/presentation/widgets/main_app_bar.dart';
import 'package:medquest/research/presentation/widgets/quest_card.dart';
import 'package:medquest/research/presentation/widgets/card_carousel.dart';
import 'package:medquest/research/presentation/widgets/research_card.dart';
import 'package:medquest/research/presentation/widgets/app_search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'MedQuest'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              AppSearchBar(
                controller: searchController,
                hintText: 'Buscar pesquisas...',
              ),
              const SizedBox(height: 20),
              CardCarousel(
                title: 'Questionários Modelos',
                cards: [
                  QuestCard(
                    title: 'EDQ - Quest R8',
                    creationDate: '18/02/25',
                    questions: '20',
                    onTap: () {
                      // Ação ao pressionar o card
                    },
                  ),
                  QuestCard(
                    title: 'EVTR - Alg 1',
                    creationDate: '18/02/25',
                    questions: '20',
                    onTap: () {
                      // Ação ao pressionar o card
                    },
                  ),
                  QuestCard(
                    title: 'RSI - Alg 2',
                    creationDate: '18/02/25',
                    questions: '20',
                    onTap: () {
                      // Ação ao pressionar o card
                    },
                  ),
                ],
              ),
              CardCarousel(
                title: 'Pesquisas Recentes',
                cards: [
                  ResearchCard(
                    title: 'EDQ - Alz R8',
                    participants: 20,
                    groups: 2,
                    researchers: 3,
                    onTap: () {},
                  ),
                  ResearchCard(
                    title: 'EVTR - Alg 1',
                    participants: 25,
                    groups: 2,
                    researchers: 4,
                    onTap: () {},
                  ),
                  ResearchCard(
                    title: 'RSI - Alg 2',
                    participants: 10,
                    groups: 2,
                    researchers: 5,
                    onTap: () {},
                  ),
                ],
              ),
            ActionButton(text: 'Nova Pesquisa', onPressed: () {}, isDark: false),
            ActionButton(text: 'Novo Questionário', onPressed: () {}, isDark: true),
            ],
          ),
        ),
      ),
    );
  }
}
