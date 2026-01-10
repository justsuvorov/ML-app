import 'package:flutter/material.dart';

Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 3,
          child: Text(value.isEmpty ? '—' : value),
        ),
      ],
    ),
  );
}

Widget buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    ),
  );
}

Widget buildFormField({
  required String label,
  required String? initialValue,
  bool isRequired = false,
  String? hintText,
  int? maxLines,
  Function(String)? onChanged,
}) {
  return TextFormField(
    initialValue: initialValue,
    decoration: InputDecoration(
      labelText: label + (isRequired ? ' *' : ''),
      border: const OutlineInputBorder(),
      hintText: hintText,
    ),
    maxLines: maxLines,
    validator: isRequired ? (value) {
      if (value == null || value.isEmpty) {
        return 'Пожалуйста, введите $label';
      }
      return null;
    } : null,
    onChanged: onChanged,
  );
}

Widget buildDropdownField<T>({
  required String label,
  required T? value,
  required List<T> options,
  required String Function(T) displayText,
  bool isRequired = false,
  Function(T?)? onChanged,
}) {
  return DropdownButtonFormField<T>(
    value: value,
    decoration: InputDecoration(
      labelText: label + (isRequired ? ' *' : ''),
      border: const OutlineInputBorder(),
    ),
    items: options.map((option) {
      return DropdownMenuItem<T>(
        value: option,
        child: Text(displayText(option)),
      );
    }).toList(),
    validator: isRequired ? (value) {
      if (value == null) {
        return 'Пожалуйста, выберите $label';
      }
      return null;
    } : null,
    onChanged: onChanged,
  );
}