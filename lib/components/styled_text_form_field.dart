import 'package:flutter/material.dart';

class StyledTextFormField extends StatelessWidget {
  const StyledTextFormField({super.key, this.label});

  final Widget? label;

  final styledBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
    borderSide: BorderSide(
      style: BorderStyle.none,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: label,
        focusedBorder: styledBorder,
        enabledBorder: styledBorder,
        errorBorder: styledBorder,
        filled: true,
        fillColor: Colors.black12,
        focusColor: Colors.black45,
        hoverColor: Colors.black45,
        focusedErrorBorder: styledBorder,
        floatingLabelStyle: const TextStyle(
          color: Colors.transparent,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '必输';
        return null;
      },
      initialValue: "12321",
    );
  }
}
