abstract class RegexApp {
  // apenas dígitos
  static final onlyNumbers = RegExp(r'[0-9]');

  // email
  static final email = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  // Ao menos 1 caracter maiusculo
  // Ao menos 1 caracter minúsculo
  // Ao menos 1 digito
  // Ao menos 1 caracter especial
  static final password = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).*$',
  );

  // Ao menos 1 caracter maiusculo
  static final hasLowerCase = RegExp(r'(?=.*[a-z])');

  // Ao menos 1 caracter minúsculo
  static final hasUpperCase = RegExp(r'(?=.*[A-Z])');

  // Ao menos 1 digito
  static final hasDigit = RegExp(r'(?=.*\d)');

  // Ao menos 1 caracter especial
  static final hasSpecialChar = RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])');
}
