import '../../../core/patterns/usecases.dart';
import '../../../core/typedefs/type_defs.dart';

abstract interface class ICreateModelQuestUseCase
    implements IUseCase<ModelQuestResult, ModelQuestParams> {}

abstract interface class IGetModelQuestUseCase
    implements IUseCase<ModelQuestResult, ModelQuestIdParams> {}

abstract interface class IGetAllModelQuestsUseCase
    implements IUseCase<ModelQuestsResult, NoParams> {}

abstract interface class IGetModelQuestsFromResearchUseCase
    implements IUseCase<ModelQuestsResult, ResearchIdParams> {}

abstract interface class IUpdateModelQuestUseCase
    implements IUseCase<ModelQuestResult, ModelQuestParams> {}

abstract interface class IDeleteModelQuestUseCase
    implements IUseCase<VoidResult, ModelQuestIdParams> {}

abstract interface class ICreateQuestionUseCase
    implements IUseCase<QuestionResult, QuestionParams> {}

abstract interface class IUpdateQuestionUseCase
    implements IUseCase<QuestionResult, QuestionParams> {}

abstract interface class IDeleteQuestionUseCase
    implements IUseCase<VoidResult, QuestionParams> {}
