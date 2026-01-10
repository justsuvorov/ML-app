import 'package:flutter/material.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_config_editor.dart';
import 'package:ml_app/presentation/core/widgets/shared_widgets.dart';

class AllModelsDataConfigSection extends StatefulWidget {
  final DataModelConfig dataConfig;
  final Function(DataModelConfig) onDataConfigChanged;
  final List<String> sourceOptions;
  final List<String> separationKindOptions;
  
  const AllModelsDataConfigSection({
    super.key,
    required this.dataConfig,
    required this.onDataConfigChanged,
    required this.sourceOptions,
    required this.separationKindOptions,
  });
  
  @override
  _AllModelsDataConfigSectionState createState() => _AllModelsDataConfigSectionState();
}

class _AllModelsDataConfigSectionState extends State<AllModelsDataConfigSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Данные',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Источник данных
            buildDropdownField<String>(
              label: 'Источник данных',
              value: widget.dataConfig.source,
              options: widget.sourceOptions,
              displayText: (option) => option,
              isRequired: true,
              onChanged: (value) {
                if (value != null) {
                  widget.onDataConfigChanged(widget.dataConfig.copyWith(source: value));
                }
              },
            ),
            
            const SizedBox(height: 12),
            
            // Имя таблицы
            buildFormField(
              label: 'Имя таблицы',
              initialValue: widget.dataConfig.tableNameSource,
              hintText: 'Введите имя таблицы',
              onChanged: (value) {
                widget.onDataConfigChanged(widget.dataConfig.copyWith(tableNameSource: value));
              },
            ),
            
            const SizedBox(height: 12),
            
            // Локальное имя файла
            buildFormField(
              label: 'Локальное имя файла',
              initialValue: widget.dataConfig.localNameSource,
              hintText: 'Путь к локальному файлу',
              onChanged: (value) {
                widget.onDataConfigChanged(widget.dataConfig.copyWith(localNameSource: value));
              },
            ),
            
            const SizedBox(height: 12),
            
            // Показ графиков
            SwitchListTile(
              title: const Text('Показ графиков'),
              value: widget.dataConfig.showGraphs ?? false,
              onChanged: (value) {
                widget.onDataConfigChanged(widget.dataConfig.copyWith(showGraphs: value));
              },
            ),
            
            const SizedBox(height: 12),
            
            // Дополнительные условия
            buildFormField(
              label: 'Дополнительные условия',
              initialValue: widget.dataConfig.extraConditions,
              hintText: 'SQL условия для фильтрации',
              maxLines: 3,
              onChanged: (value) {
                widget.onDataConfigChanged(widget.dataConfig.copyWith(extraConditions: value));
              },
            ),
            
            const SizedBox(height: 16),
            
            // Разделение данных
            _buildSeparationSection(),
            
            const SizedBox(height: 16),
            
            // Дополнительные колонки
            buildFormField(
              label: 'Дополнительные поля',
              initialValue: widget.dataConfig.extraColumns?.join(', '),
              hintText: 'col1, col2, col3',
              onChanged: (value) {
                final columns = value.split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                widget.onDataConfigChanged(widget.dataConfig.copyWith(extraColumns: columns));
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSeparationSection() {
    final separation = widget.dataConfig.separation;
    
    if (separation == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Разделение данных',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              widget.onDataConfigChanged(widget.dataConfig.copyWith(
                separation: SeparationModelConfig(
                  kind: 'random',
                  randomState: 42,
                  testTrainProportion: 0.3,
                ),
              ));
            },
            child: const Text('Добавить разделение данных'),
          ),
        ],
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Разделение данных',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                widget.onDataConfigChanged(widget.dataConfig.copyWith(separation: null));
              },
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
        
        // Тип разделения
        buildDropdownField<String>(
          label: 'Тип разделения',
          value: separation.kind,
          options: widget.separationKindOptions,
          displayText: (option) => option,
          onChanged: (value) {
            if (value != null) {
              widget.onDataConfigChanged(widget.dataConfig.copyWith(
                separation: separation.copyWith(kind: value),
              ));
            }
          },
        ),
        
        const SizedBox(height: 12),
        
        // Random State
        buildFormField(
          label: 'Random State',
          initialValue: separation.randomState?.toString(),
          hintText: '42',
          onChanged: (value) {
            widget.onDataConfigChanged(widget.dataConfig.copyWith(
              separation: separation.copyWith(
                randomState: int.tryParse(value),
              ),
            ));
          },
        ),
        
        const SizedBox(height: 12),
        
        // Test/Train proportion
        buildDoubleSliderWithValue(
          label: 'Test/Train proportion',
          value: separation.testTrainProportion ?? 0.3,
          min: 0.1,
          max: 0.9,
          divisions: 16,
          onChanged: (value) {
            widget.onDataConfigChanged(widget.dataConfig.copyWith(
              separation: separation.copyWith(testTrainProportion: value),
            ));
          },
        ),
        
        const SizedBox(height: 12),
        
        // Периоды для обучения и тестирования
        if (separation.kind == 'date') ...[
          buildFormField(
            label: 'Период обучения',
            initialValue: separation.trainPeriod?.join(', '),
            hintText: '2023-01-01, 2023-06-30',
            onChanged: (value) {
              final periods = value.split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              widget.onDataConfigChanged(widget.dataConfig.copyWith(
                separation: separation.copyWith(trainPeriod: periods),
              ));
            },
          ),
          
          const SizedBox(height: 12),
          
          buildFormField(
            label: 'Период тестирования',
            initialValue: separation.testPeriod?.join(', '),
            hintText: '2023-07-01, 2023-12-31',
            onChanged: (value) {
              final periods = value.split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              widget.onDataConfigChanged(widget.dataConfig.copyWith(
                separation: separation.copyWith(testPeriod: periods),
              ));
            },
          ),
          
          const SizedBox(height: 12),
          
          buildFormField(
            label: 'Имя поля даты',
            initialValue: separation.periodColumn?.join(', '),
            hintText: 'date_column',
            onChanged: (value) {
              final columns = value.split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              widget.onDataConfigChanged(widget.dataConfig.copyWith(
                separation: separation.copyWith(periodColumn: columns),
              ));
            },
          ),
        ],
      ],
    );
  }
}