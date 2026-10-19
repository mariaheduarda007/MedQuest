import '../failure/failure.dart';
import '../messages/messages.dart';
import 'base_validator.dart';


final class EmptyStrValidator extends BaseValidator<String?> {
  EmptyStrValidator();

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
          AppMessages.error.nullStringError,
        ),
      _ => nextValidator?.validate(validation) ?? true,
      //     _ => throw DefaultError(MessagesError.emptyFieldError),
    };
  }
}