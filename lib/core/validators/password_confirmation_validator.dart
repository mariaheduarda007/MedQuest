import '../failure/failure.dart';
import '../messages/messages.dart';
import 'base_validator.dart';

final class PasswordConfirmationValidator extends BaseValidator<String?> {
  
  final String password;

  PasswordConfirmationValidator(this.password);

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
          AppMessages.error.nullStringError,
        ),
      String v when v.compareTo(password) !=0 => throw PasswordNotConfirmed(
          AppMessages.error.passwordMismatchError,
        ),
      _ => nextValidator?.validate(validation) ?? true,
    };
  }
}