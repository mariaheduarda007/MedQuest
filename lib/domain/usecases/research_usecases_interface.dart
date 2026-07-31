import '../../core/patterns/usecases.dart';
import '../../core/typedefs/type_defs.dart';

abstract interface class ICreateResearchUseCase
    implements IUseCase<ResearchResult, ResearchParams> {}

abstract interface class IGetResearchUseCase
    implements IUseCase<ResearchResult, ResearchIdParams> {}

abstract interface class IGetResearchesUseCase
    implements IUseCase<ResearchesResult, ResearchesIdParams> {}

abstract interface class IUpdateResearchUseCase
    implements IUseCase<ResearchResult, ResearchParams> {}

abstract interface class IDeleteResearchUseCase
    implements IUseCase<VoidResult, ResearchIdParams> {}

abstract interface class IArchiveResearchUseCase
    implements IUseCase<VoidResult, ResearchIdParams> {}

abstract interface class IUnarchiveResearchUseCase
    implements IUseCase<VoidResult, ResearchIdParams> {}
