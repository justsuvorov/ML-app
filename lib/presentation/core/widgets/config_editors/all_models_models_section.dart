import 'package:flutter/material.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_config_editor.dart';
import 'package:ml_app/presentation/core/widgets/shared_widgets.dart';

Widget buildModelsInfoSection({
  required List<ModelConfig> models,
  required Function(int) onEditModel,
  required Function() onAddModel,
  required Function(int, int) onEditFeature,
  required Function(int) onAddFeature,
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Модели',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Chip(
                label: Text('${models.length} шт.'),
                backgroundColor: Colors.blue[100],
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          
          // Список моделей
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              final featureCount = model.features.length;
              final relativeFeatureCount = model.relativeFeatures.length;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    model.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('objective: ${model.objective ?? "не указана"}'),
                      Text('wrapper: ${model.wrapper ?? "не указана"}'),
                      Text('Фичи: $featureCount основных, $relativeFeatureCount относительных'),
                      if (model.columnTarget != null)
                        Text('Таргет: ${model.columnTarget}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => onEditModel(index),
                ),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          // Кнопка для добавления новой модели
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddModel,
              icon: const Icon(Icons.add),
              label: const Text('Добавить новую модель'),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildModelEditForm({
  required ModelConfig model,
  required int modelIndex,
  required Function(ModelConfig) onModelChanged,
  required Function(int) onAddFeature,
  required Function(int, int) onEditFeature,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Редактировать модель',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        // Название модели
        buildFormField(
          label: 'Название модели',
          initialValue: model.name,
          isRequired: true,
          onChanged: (value) => onModelChanged(model.copyWith(name: value)),
        ),
        
        const SizedBox(height: 12),
        
        // Objective
        buildFormField(
          label: 'Objective',
          initialValue: model.objective ?? '',
          hintText: 'poisson, gamma, binary, RMSE, rmsewithuncertainty',
          onChanged: (value) => onModelChanged(model.copyWith(
            objective: value.isEmpty ? null : value,
          )),
        ),
        
        const SizedBox(height: 12),
        
        // Wrapper
        buildFormField(
          label: 'Wrapper',
          initialValue: model.wrapper ?? '',
          hintText: 'glm, glm_without_scaler, catboost, catboost_over_glm, xgboost',
          onChanged: (value) => onModelChanged(model.copyWith(
            wrapper: value.isEmpty ? null : value,
          )),
        ),
        
        const SizedBox(height: 12),
        
        // Целевая колонка
        buildFormField(
          label: 'Целевая колонка',
          initialValue: model.columnTarget ?? '',
          hintText: 'target_column',
          onChanged: (value) => onModelChanged(model.copyWith(
            columnTarget: value.isEmpty ? null : value,
          )),
        ),
        
        const SizedBox(height: 12),
        
        // Колонка экспозиции
        buildFormField(
          label: 'Экспозиция',
          initialValue: model.columnExposure ?? '',
          hintText: 'exposure_column',
          onChanged: (value) => onModelChanged(model.copyWith(
            columnExposure: value.isEmpty ? null : value,
          )),
        ),
        
        const SizedBox(height: 12),
        
        // Условие фильтрации
        buildFormField(
          label: 'Условие фильтрации',
          initialValue: model.dataFilterCondition ?? '',
          hintText: 'WHERE condition',
          maxLines: 2,
          onChanged: (value) => onModelChanged(model.copyWith(
            dataFilterCondition: value.isEmpty ? null : value,
          )),
        ),
        
        const SizedBox(height: 20),
        
        // Раздел для фичей
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Фичи модели',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Chip(
              label: Text('${model.features.length} шт.'),
              backgroundColor: Colors.green[100],
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Список фичей
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.features.length,
          itemBuilder: (context, featureIndex) {
            final feature = model.features[featureIndex];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(feature.name),
                subtitle: Text(
                  'Default: ${feature.defaultValue}, '
                  'Encoding: ${feature.encoding ?? "нет"}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => onEditFeature(modelIndex, featureIndex),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Кнопка добавления фичи
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => onAddFeature(modelIndex),
            icon: const Icon(Icons.add),
            label: const Text('Добавить фичу'),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Кнопки сохранения/отмены
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Закрытие происходит в вызывающем виджете
                },
                child: const Text('Сохранить'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Закрытие происходит в вызывающем виджете
                },
                child: const Text('Отмена'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}