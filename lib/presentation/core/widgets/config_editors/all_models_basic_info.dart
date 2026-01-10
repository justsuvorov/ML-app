import 'package:flutter/material.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_config_editor.dart';


Widget buildBasicInfoSection({
  required AllModelsConfig config,
  required Function(AllModelsConfig) onConfigChanged,
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Основная информация',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 16),
          
          buildFormField(
            label: 'Проект',
            initialValue: config.project,
            isRequired: true,
            hintText: 'Введите название проекта',
            onChanged: (value) {
              onConfigChanged(config.copyWith(project: value));
            },
          ),
          
          const SizedBox(height: 12),
          
          buildFormField(
            label: 'Версия',
            initialValue: config.version,
            isRequired: true,
            hintText: 'Введите версию',
            onChanged: (value) {
              onConfigChanged(config.copyWith(version: value));
            },
          ),
          
          const SizedBox(height: 12),
          
          buildFormField(
            label: 'Группа моделей',
            initialValue: config.groupName,
            isRequired: true,
            hintText: 'Введите название группы моделей',
            onChanged: (value) {
              onConfigChanged(config.copyWith(groupName: value));
            },
          ),
          
          const SizedBox(height: 12),
          
         
        ],
      ),
    ),
  );
}