import 'package:flutter/material.dart';

class FieldTextConfig {
  final TextEditingController controller;
  final bool isValid;
  final String labelText;
  final String? hintText;
  final String? error;
  final bool isNumberOnly;
  final bool isTomanCost;
  final bool isNotes;
  final void Function(String)? onChanged;

  const FieldTextConfig({
    required this.controller,
    required this.isValid,
    required this.labelText,
    this.hintText,
    this.error,
    this.isNumberOnly = false,
    this.isTomanCost = false,
     this.isNotes = false,
    this.onChanged,
  });
}
