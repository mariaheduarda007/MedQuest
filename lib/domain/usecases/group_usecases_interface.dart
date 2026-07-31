import '../../core/patterns/usecases.dart';
import '../../core/typedefs/type_defs.dart';

abstract interface class ICreateGroupUseCase
    implements IUseCase<GroupResult, GroupParams> {}

abstract interface class IGetGroupUseCase
    implements IUseCase<GroupResult, GroupIdParams> {}

abstract interface class IGetGroupsUseCase
    implements IUseCase<GroupsResult, ResearchIdParams> {}

abstract interface class IDeleteGroupUseCase
    implements IUseCase<VoidResult, GroupIdParams> {}
