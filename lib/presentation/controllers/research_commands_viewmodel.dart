import 'package:medquest/domain/models/research_entity.dart';
import 'package:medquest/presentation/commands/research_commands.dart';
import 'package:medquest/presentation/controllers/research_state_viewmodel.dart';
import '../../core/failure/failure.dart';
import '../../core/patterns/command.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ResearchCommandsViewModel {
  final ResearchStateViewModel state;
  final CreateResearchCommand _createResearchCommand;
  final GetResearchCommand _getResearchCommand;
  final GetResearchesCommand _getResearchesCommand;
  final UpdateResearchCommand _updateResearchCommand;
  final DeleteResearchCommand _deleteResearchCommand;
  final ArchiveResearchCommand _archiveResearchCommand;
  final UnarchiveResearchCommand _unarchiveResearchCommand;

  ResearchCommandsViewModel({
    required this.state,
    required CreateResearchCommand createResearchCommand,
    required GetResearchCommand getResearchCommand,
    required GetResearchesCommand getResearchesCommand,
    required UpdateResearchCommand updateResearchCommand,
    required DeleteResearchCommand deleteResearchCommand,
    required ArchiveResearchCommand archiveResearchCommand,
    required UnarchiveResearchCommand unarchiveResearchCommand,
  }) : _createResearchCommand = createResearchCommand,
       _getResearchCommand = getResearchCommand,
       _getResearchesCommand = getResearchesCommand,
       _updateResearchCommand = updateResearchCommand,
       _deleteResearchCommand = deleteResearchCommand,
       _archiveResearchCommand = archiveResearchCommand,
       _unarchiveResearchCommand = unarchiveResearchCommand {
    // Observers para cada comando
    _observeCreateResearch();
    _observeGetResearch();
    _observeGetResearches();
    _observeUpdateResearch();
    _observeDeleteResearch();
    _observeArchiveResearch();
    _observeUnarchiveResearch();  
  }

  // ========================================================
  //   GETTERS PARA WIDGETS USAREM DIRETAMENTE OS COMANDOS
  // ========================================================
  CreateResearchCommand get createResearchCommand => _createResearchCommand;
  GetResearchCommand get getResearchCommand => _getResearchCommand;
  GetResearchesCommand get getResearchesCommand => _getResearchesCommand;
  UpdateResearchCommand get updateResearchCommand => _updateResearchCommand;
  DeleteResearchCommand get deleteResearchCommand => _deleteResearchCommand;
  ArchiveResearchCommand get archiveResearchCommand => _archiveResearchCommand;
  UnarchiveResearchCommand get unarchiveResearchCommand => _unarchiveResearchCommand;

  // ========================================================
  //   MÉTODO GENÉRICO DE OBSERVAÇÃO DE COMANDOS
  // ========================================================
  void _observeCommand<T>(
    Command<T, Failure> command, {
    required void Function(T data) onSuccess,
    void Function(Failure err)? onFailure,
  }) {
    effect(() {
      // 1) Ignora enquanto está executando
      if (command.isExecuting.value) return;

      // 2) Ignora até existir um resultado
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
          command.clear(); // Limpa o resultado para evitar reprocessamento
        },
      );
    });
  }

  // ========================================================
  //   OBSERVERS ESPECÍFICOS
  // ========================================================

  void _observeCreateResearch() {
    _observeCommand<Research>(
      _createResearchCommand,
      onSuccess: (research) {
        state.setResearch(research);
        state.successEvent.value = ResearchSuccessEvent.created;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeGetResearch() {
    _observeCommand<Research>(
      _getResearchCommand,
      onSuccess: (research) {
        state.setResearch(research);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      }, //redundante, pois o generico já faz isso, mas mantido para verificar minha suposição
    );
  }

  void _observeGetResearches() {
    _observeCommand<List<Research>>(
      _getResearchesCommand,
      onSuccess: (researches) {
        state.setResearches(researches);
        state.clearMessage();
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeUpdateResearch() {
    _observeCommand<Research>(
      _updateResearchCommand,
      onSuccess: (research) {
        state.setResearch(research);
        state.successEvent.value = ResearchSuccessEvent.updated;
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeDeleteResearch() {
    _observeCommand<void>(
      _deleteResearchCommand,
      onSuccess: (_) {
        state.successEvent.value = ResearchSuccessEvent.deleted;
        state.setResearch(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeArchiveResearch() {
    _observeCommand<void>(
      _archiveResearchCommand,
      onSuccess: (_) {
        state.successEvent.value = ResearchSuccessEvent.archived;
        state.setResearch(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  void _observeUnarchiveResearch() {
    _observeCommand<void>(
      _unarchiveResearchCommand,
      onSuccess: (_) {
        state.successEvent.value = ResearchSuccessEvent.unarchived;
        state.setResearch(null);
      },
      onFailure: (err) {
        state.setMessage(err.msg);
      },
    );
  }

  // ========================================================
  //   MÉTODOS PÚBLICOS QUE DISPARAM COMMANDS (CHAMADOS PELOS WIDGETS)
  // ========================================================
    //só executa o command, state e suas funções são atualizados pelos observers
  Future<void> createResearch(Research research) async {
    await _createResearchCommand.executeWith((research: research));
  }

  Future<void> getResearch(String researchId) async {
    await _getResearchCommand.executeWith((researchId: researchId));
  }

Future<void> getResearches(List<String> researchesId) async {
    await _getResearchesCommand.executeWith((researchesId: researchesId));
  }

  Future<void> updateResearch(Research research) async {
    await _updateResearchCommand.executeWith((research: research));
  }

  Future<void> deleteResearch(String researchId) async {
    await _deleteResearchCommand.executeWith((researchId: researchId));
  }

  Future<void> archiveResearch(String researchId) async {
    await _archiveResearchCommand.executeWith((researchId: researchId));
  }

  Future<void> unarchiveResearch(String researchId) async {
    await _unarchiveResearchCommand.executeWith((researchId: researchId));
  }
}
