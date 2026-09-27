import 'package:flutter/material.dart';
import 'package:medquest/core/theme/theme.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;


  const AppSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      height: 45,
      child:
       TextField(
        controller: controller,
        cursorColor: const Color(0xFF4D2855),
        onChanged: onChanged,
        style: context.textStyles.labelMedium
                        ?.bold
                        .withColor(context.colors.onPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.textStyles.labelMedium
                        ?.bold
                        .withColor(context.colors.onPrimary),
          
          prefixIcon: Icon(
            Icons.search,
            size: 30,
            color: context.colors.onPrimary,
          ),
          filled: true,
          fillColor: context.colors.primary,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: context.colors.onPrimary,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: context.colors.onPrimary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: context.colors.onPrimary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}