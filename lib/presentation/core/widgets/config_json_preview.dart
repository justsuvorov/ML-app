import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';

class ConfigJsonPreview {
  static void showAutoMLJsonPreview(BuildContext context, AutoMLConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AutoML Config JSON'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              JsonEncoder.withIndent('  ').convert(config.toJson()),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
  
  static void showAllModelsJsonPreview(BuildContext context, AllModelsConfig config) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AllModels Config JSON'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              JsonEncoder.withIndent('  ').convert(config.toJson()),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}