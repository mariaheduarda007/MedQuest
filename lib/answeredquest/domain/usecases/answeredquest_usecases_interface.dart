import '../../../core/patterns/usecases.dart';
import '../../../core/typedefs/type_defs.dart';

abstract interface class ICreateAnsweredQuestUseCase
    implements IUseCase<AnsweredQuestResult, AnsweredQuestParams> {}

abstract interface class IGetAnsweredQuestUseCase
    implements IUseCase<AnsweredQuestResult, AnsweredQuestIdParams> {}

abstract interface class IGetAnsweredQuestsUseCase
    implements IUseCase<AnsweredQuestsResult, PatientQuestsParams> {}

abstract interface class IUpdateAnsweredQuestUseCase
    implements IUseCase<AnsweredQuestResult, AnsweredQuestParams> {}

abstract interface class IDeleteAnsweredQuestUseCase
    implements IUseCase<VoidResult, AnsweredQuestIdParams> {}
