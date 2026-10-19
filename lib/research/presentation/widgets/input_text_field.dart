import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool password;

  const InputTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.password = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}


class _InputTextFieldState extends State<InputTextField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.password && !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: context.colors.onSurface),
      cursorColor: context.colors.secondary,
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: widget.password
                    ? IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: context.colors.onPrimary,
                        ),
                        onPressed: () {
                          _togglePasswordVisibility();
                        },
                      )
                    : null,
              
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.outline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.secondary),
        ),
      ),
      validator: widget.validator,
    );
  }
}
