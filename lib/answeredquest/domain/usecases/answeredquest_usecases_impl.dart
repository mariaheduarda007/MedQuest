import 'package:medquest/answeredquest/domain/usecases/answeredquest_usecases_interface.dart';
import '../../../core/typedefs/type_defs.dart';
import '../../data/repository/answeredquest_repository_interface.dart';

final class CreateAnsweredQuestUseCaseImpl
    implements ICreateAnsweredQuestUseCase {
  final IAnsweredQuestRepository _repository;

  CreateAnsweredQuestUseCaseImpl({required IAnsweredQuestRepository repository})
    : _repository = repository;

  @override
  Future<AnsweredQuestResult> call(CreateAnsweredQuestParams params) async {
    return _repository.createAnsweredQuest(params);
  }
}

final class GetAnsweredQuestUseCaseImpl implements IGetAnsweredQuestUseCase {
  final IAnsweredQuestRepository _repository;

  GetAnsweredQuestUseCaseImpl({required IAnsweredQuestRepository repository})
    : _repository = repository;

  @override
  Future<AnsweredQuestResult> call(AnsweredQuestIdParams params) async {
    return _repository.getAnsweredQuest(params);
  }
}

final class GetAnsweredQuestsUseCaseImpl implements IGetAnsweredQuestsUseCase {
  final IAnsweredQuestRepository _repository;

  GetAnsweredQuestsUseCaseImpl({required IAnsweredQuestRepository repository})
    : _repository = repository;

  @override
  Future<AnsweredQuestsResult> call(PatientParams params) async {
    return _repository.getAnsweredQuests(params);
  }
}

final class UpdateAnsweredQuestUseCaseImpl
    implements IUpdateAnsweredQuestUseCase {
  final IAnsweredQuestRepository _repository;

  UpdateAnsweredQuestUseCaseImpl({required IAnsweredQuestRepository repository})
    : _repository = repository;

  @override
  Future<AnsweredQuestResult> call(AnsweredQuestParams params) async {
    return _repository.updateAnsweredQuest(params);
  }
}

final class DeleteAnsweredQuestUseCaseImpl
    implements IDeleteAnsweredQuestUseCase {
  final IAnsweredQuestRepository _repository;

  DeleteAnsweredQuestUseCaseImpl({required IAnsweredQuestRepository repository})
    : _repository = repository;

  @override
  Future<VoidResult> call(AnsweredQuestIdParams params) async {
    return _repository.deleteAnsweredQuest(params);
  }
}
