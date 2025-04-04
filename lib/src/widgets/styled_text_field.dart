import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final int minLines;
  final bool autoFocus;
  final String? helperText;
  final int? maxLength;
  final bool title;
  final TextEditingController controller;

  const StyledTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.autoFocus = false,
    this.minLines = 1,
    this.helperText,
    this.maxLength,
    this.title = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: minLines,
      maxLines: minLines,
      autofocus: autoFocus,
      maxLength: maxLength,
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: const [
        CapitalizeFirstLetterFormatter(),
      ],
      style: title
          ? Theme.of(context).textTheme.titleLarge
          : Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        labelText: label,
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.8),
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  const CapitalizeFirstLetterFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text[0].toUpperCase() + newValue.text.substring(1);
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
