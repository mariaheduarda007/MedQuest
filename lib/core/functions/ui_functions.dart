import 'package:flutter/material.dart';

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

