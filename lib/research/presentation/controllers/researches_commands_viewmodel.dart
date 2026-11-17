import 'package:medquest/core/failure/failure.dart';
import 'package:medquest/core/patterns/command.dart';
import 'package:medquest/research/domain/facade/research_facade_usecases_interface.dart';
import 'package:medquest/research/presentation/commands/research_commands.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'researches_state_viewmodel.dart';

class ResearchesCommandsViewModel {
  final ResearchesStateViewModel state;
  final GetResearchesCommand _getResearchesCommand;

  ResearchesCommandsViewModel({
    required this.state,
    required IResearchFacadeUseCases researchFacade,
  }) : _getResearchesCommand = GetResearchesCommand(researchFacade) {
    _observeGetResearches();
  }

  GetResearchesCommand get getResearchesCommand => _getResearchesCommand;

  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      if (command.isExecuting.value) return;

      final result = command.result.value;
      if (result == null) return;

      result.fold(
        onSuccess: (data) {
          state.clearMessage();
          onSuccess(data);
          command.clear();
        },
        onFailure: (err) {
          state.setMessage(err.msg);
          if (onFailure != null) onFailure(err);
          command.clear();
        },
      );
    });
  }

  void _observeGetResearches() {
    _observeCommand(
      _getResearchesCommand,
      onSuccess: (researches) {
        state.setResearches(researches);
      },
      onFailure: (failure) {
        state.setMessage(failure.msg);
      },
    );
  }

  Future<void> getResearches({List<String> researchesId = const []}) async {
    state.clearMessage();
    await _getResearchesCommand.executeWith((researchesId: researchesId));
  }
}


