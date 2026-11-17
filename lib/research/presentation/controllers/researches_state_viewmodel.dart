import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ResearchesStateViewModel {
  final researchesState = Signal<List<Research>>([]);
  final message = signal<String?>(null);

  void setResearches(List<Research> researches) =>
      researchesState.value = researches;

  void clearMessage() => message.value = null;

  void setMessage(String value) => message.value = value;
}
