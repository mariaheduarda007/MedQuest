import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../core/failure/failure.dart';
import '../../core/messages/messages.dart';
import '../../core/validators/base_validator.dart';
import '../../core/validators/text_field_validator.dart';

/// validacoes de campos de texto
String? validateField(String? value, List<BaseValidator> validators) {
  try {
    final isValid = TextFieldValidator(
      validators: validators,
    ).validations(value);

    if (!isValid) {
      return AppMessages.error.defaultError;
    }

    return null;
  } on Failure catch (e) {
    return e.msg;
  } catch (e) {
    return e.toString();
  }
}

String dateFormat(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

int calculateAge(DateTime birthDate) {
  final today = DateTime.now();

  int age = today.year - birthDate.year;

  final hasNotHadBirthday =
      today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day);

  if (hasNotHadBirthday) {
    age--;
  }

  return age;
}
