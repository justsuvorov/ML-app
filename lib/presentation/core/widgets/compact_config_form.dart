import 'package:flutter/material.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/shared_widgets.dart';

class CompactConfigForm extends StatelessWidget {
  final AutoMLConfig config;
  final VoidCallback onShowJson;
  final VoidCallback onEdit;
  
  const CompactConfigForm({
    Key? key,
    required this.config,
    required this.onShowJson,
    required this.onEdit,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final fs = config.featureSelection;
    final hp = config.hpTune;
    final ic = config.inferenceCriteria;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AutoML Configuration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Основная информация
          buildSectionTitle('Основная информация'),
          buildInfoRow('Проект', config.project),
          buildInfoRow('Группа', config.groupName),
          buildInfoRow('MLflow', config.mlflowExperiment),
          buildInfoRow('Grafana', config.grafanaTableName),
          buildInfoRow('Дашборд', config.dashboardName),
          
          const SizedBox(height: 16),
          
          // Feature Selection
          buildSectionTitle('Feature Selection'),
          buildTwoColumnRow('Кол-во фичей для модели', '${fs.topFeaturesToSelect}', 'Максемальное количество категорий', '${fs.countCategory}'),
          buildTwoColumnRow('Cutoff 1 Cat', '${fs.cutoff1Category}', 'Cutoff NaN', '${fs.cutoffNan}'),
          buildTwoColumnRow('Max Corr', '${fs.maxCorrValue}', 'Depth', '${fs.depth}'),
          buildTwoColumnRow('Энкодинг  кат. фичей', fs.encodingCat, 'Энкодинг числ. фичей', fs.encodingNum),
          buildTwoColumnRow('Default Cat', fs.defaultCat, 'Default Num', fs.defaultNum),
          
          if (fs.featuresToIgnore.isNotEmpty)
            buildInfoRow('Игнорируемые', fs.featuresToIgnore.join(', ')),
          
          const SizedBox(height: 16),
          
          // HP Tuning
          buildSectionTitle('HP Tuning'),
          buildTwoColumnRow('Сэмплинг', hp.sampling, 'CV Folds', '${hp.cvFoldsNum}'),
          
          const SizedBox(height: 16),
          
          // Inference
          buildSectionTitle('Model Inference'),
          buildInfoRow('Папка моделей', ic.prodModelsFolder),
          buildInfoRow('Thresholds', ic.threshold.map((t) => t.toStringAsFixed(2)).join(', ')),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onShowJson,
                  child: const Text('Показать JSON'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Редактировать'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CompactAllModelsConfigForm extends StatelessWidget {
  final AllModelsConfig config;
  final VoidCallback onShowJson;
  final VoidCallback? onEdit;
  
  const CompactAllModelsConfigForm({
    Key? key,
    required this.config,
    required this.onShowJson,
    this.onEdit,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final dataConfig = config.dataConfig;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Models Configuration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Основная информация
          buildSectionTitle('Основная информация'),
          buildInfoRow('Группа моделей', config.groupName),
          buildInfoRow('Проект', config.project),
          buildInfoRow('Версия', config.version),
          buildInfoRow('Количество моделей', '${config.modelsConfigs.length}'),
          
          const SizedBox(height: 16),
          
          // Конфигурация данных
          if (dataConfig != null) ...[
            buildSectionTitle('Конфигурация данных'),
            buildInfoRow('Источник данных', dataConfig.source ?? '—'),
            buildInfoRow('Имя таблицы', dataConfig.tableNameSource ?? ''),
            buildInfoRow('Путь к локальному файлу', dataConfig.localNameSource ?? '—'),
            
            if (dataConfig.extraColumns != null && dataConfig.extraColumns!.isNotEmpty)
              buildInfoRow('Дополнительные поля', dataConfig.extraColumns!.join(', ')),
            
            if (dataConfig.separation != null) ...[
              const SizedBox(height: 8),
              buildInfoRow('Разделение на тестовую и обучающую выборку', dataConfig.separation!.kind),
              if (dataConfig.separation!.randomState != null)
                buildInfoRow('Random State', '${dataConfig.separation!.randomState}'),
              if (dataConfig.separation!.testTrainProportion != null)
                buildInfoRow('Test/Train proportion', dataConfig.separation!.testTrainProportion!.toStringAsFixed(2)),
            ],
          ],
          
          const SizedBox(height: 16),
          
          // Краткая информация о моделях
          buildSectionTitle('Конфигурация моделей'),
          ...config.modelsConfigs.take(3).map((model) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Цель: ${model.objective ?? "default"}, Фичей: ${model.features.length}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (model.paramsCatboost != null)
                    buildInfoCard('CatBoost', '${model.paramsCatboost!.length} пар.'),
                  if (model.paramsXgb != null)
                    buildInfoCard('XGBoost', '${model.paramsXgb!.length} пар.'),
                ],
              ),
            );
          }).toList(),
          
          if (config.modelsConfigs.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '... и еще ${config.modelsConfigs.length - 3} моделей',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Кнопки
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onShowJson,
                  child: const Text('Показать JSON'),
                ),
              ),
              if (onEdit != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEdit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Редактировать'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}