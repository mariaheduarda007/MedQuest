import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';

class AppForm extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final bool password;
  final String title;
    final String? Function(String?)? validator;

  const AppForm({
    super.key,
    required this.controller,
    this.onChanged,
    required this.hintText,
    required this.title,
    this.password = false,
    this.validator,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: context.textStyles.labelMedium?.bold.withColor(
              context.colors.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 45,
            child: TextFormField(
              validator: widget.validator,
              obscureText: widget.password && !_isPasswordVisible,
              controller: widget.controller,
              cursorColor: context.colors.onPrimary,
              onChanged: widget.onChanged,
              style: context.textStyles.labelMedium?.bold.withColor(
                context.colors.onPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: context.textStyles.labelMedium?.bold.withColor(
                  context.colors.onPrimary,
                ),
                filled: true,
                fillColor: context.colors.primary,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: context.colors.onPrimary,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: context.colors.onPrimary,
                    width: 2,
                  ),
                ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
