import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/shared_widgets.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_basic_info.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_data_config.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_models_section.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_config_editor.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_feature_editor.dart';

class AutoMLConfigEditor extends StatefulWidget {
  final AutoMLConfig initialConfig;
  final Function(AutoMLConfig)? onSave;
  
  const AutoMLConfigEditor({
    super.key,
    required this.initialConfig,
    this.onSave,
  });
  
  @override
  _AutoMLConfigEditorState createState() => _AutoMLConfigEditorState();
}

class _AutoMLConfigEditorState extends State<AutoMLConfigEditor> {
  late AutoMLConfig _config;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _saveError;
  final List<String> _encodingcatOptions = [
  
    "WoE_cat_to_num",
    "to_float",
    "to_int",
]; 
  final List<String> _encodingnumOptions = [
    "WoE_num_to_cat",
    "WoE_num_to_num",
    "cut_num",
];
  final List<String> _defaultNumOptions = [
    '_MIN_',
    '_MAX_',
    '_MEAN_',
    '_MEDIAN_',
];
final List<String> _defaultCatOptions = [
    '_NAN_',
];

final List<String> _samplingOptions = [
  'TPE', 'RandomSampler', 'CmaEsSampler',
];

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }
  
  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    
    try {
      // Здесь будет POST запрос к FastAPI
      // final savedConfig = await _postConfigToAPI(_config);
      
      // Пока просто имитируем сохранение
      await Future.delayed(const Duration(seconds: 1));
      
      if (widget.onSave != null) {
        widget.onSave!(_config);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Конфигурация успешно сохранена!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, _config);
    } catch (e) {
      setState(() {
        _saveError = e.toString();
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать конфигурацию'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveConfig,
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: _buildEditorForm(),
    );
  }
  
  Widget _buildEditorForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Основная информация
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            
            // Feature Selection
            _buildFeatureSelectionSection(),
            const SizedBox(height: 24),
            
            // HP Tuning
            _buildHPTuningSection(),
            const SizedBox(height: 24),
            
            // Model Inference
            _buildInferenceSection(),
            const SizedBox(height: 24),
            
            // Ошибка сохранения
            if (_saveError != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_saveError!)),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Кнопки сохранения
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveConfig,
                    icon: _isSaving 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSaving ? 'Сохранение...' : 'Сохранить'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBasicInfoSection() {
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
            
            TextFormField(
              initialValue: _config.project,
              decoration: const InputDecoration(
                labelText: 'Проект *',
                border: OutlineInputBorder(),
                hintText: 'Введите название проекта',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название проекта';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(project: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.groupName,
              decoration: const InputDecoration(
                labelText: 'Группа *',
                border: OutlineInputBorder(),
                hintText: 'Введите название группы',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название группы';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(groupName: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.mlflowExperiment,
              decoration: const InputDecoration(
                labelText: 'MLflow Эксперимент *',
                border: OutlineInputBorder(),
                hintText: 'Название эксперимента в MLflow',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название эксперимента';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(mlflowExperiment: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.grafanaTableName,
              decoration: const InputDecoration(
                labelText: 'Grafana Таблица *',
                border: OutlineInputBorder(),
                hintText: 'Название таблицы в Grafana',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название таблицы';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(grafanaTableName: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.dashboardName,
              decoration: const InputDecoration(
                labelText: 'Дашборд *',
                border: OutlineInputBorder(),
                hintText: 'Название дашборда',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите название дашборда';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(dashboardName: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureSelectionSection() {
    final fs = _config.featureSelection;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feature Selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Слайдер для выбора количества фичей
            buildSliderWithValue(
              label: 'Количество фичей для модели',
              value: fs.topFeaturesToSelect.toDouble(),
              min: 1,
              max: 200,
              divisions: 99,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(
                      topFeaturesToSelect: value.toInt(),
                    ),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Слайдер для максимального количества категорий
            buildSliderWithValue(
              label: 'Максимальное количество категорий',
              value: fs.countCategory.toDouble(),
              min: 2,
              max: 100,
              divisions: 48,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(
                      countCategory: value.toInt(),
                    ),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Слайдеры для Cutoff значений
            buildDoubleSliderWithValue(
              label: 'Cutoff 1 Cat',
              value: fs.cutoff1Category,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(cutoff1Category: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            buildDoubleSliderWithValue(
              label: 'Cutoff NaN',
              value: fs.cutoffNan,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(cutoffNan: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            buildDoubleSliderWithValue(
              label: 'Максимальная корреляция',
              value: fs.maxCorrValue,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(maxCorrValue: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            buildDoubleSliderWithValue(
              label: 'Минимальная доля категории',
              value: fs.depth,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(depth: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Dropdown для энкодинга категориальных фичей
            DropdownButtonFormField<String>(
              value: fs.encodingCat,
              decoration: const InputDecoration(
                labelText: 'Энкодинг категориальных фичей',
                border: OutlineInputBorder(),
              ),
              items: _encodingcatOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(
                      featureSelection: fs.copyWith(encodingCat: value),
                    );
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Dropdown для энкодинга числовых фичей
            DropdownButtonFormField<String>(
              value: fs.encodingNum,
              decoration: const InputDecoration(
                labelText: 'Энкодинг числовых фичей',
                border: OutlineInputBorder(),
              ),
              items: _encodingnumOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(
                      featureSelection: fs.copyWith(encodingNum: value),
                    );
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Значения по умолчанию
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fs.defaultCat,
                    decoration: const InputDecoration(
                      labelText: 'Default для категорий',
                      border: OutlineInputBorder(),
                    ),
                    items: _defaultCatOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _config = _config.copyWith(
                            featureSelection: fs.copyWith(defaultCat: value),
                          );
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fs.defaultNum,
                    decoration: const InputDecoration(
                      labelText: 'Default для чисел',
                      border: OutlineInputBorder(),
                    ),
                    items: _defaultNumOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _config = _config.copyWith(
                            featureSelection: fs.copyWith(defaultNum: value),
                          );
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // CV Diff Value (optional)
            buildDoubleSliderWithValue(
              label: 'CV Diff Value (опционально)',
              value: fs.cvDiffValue ?? 1.00,
              min: 0.0,
              max: 1.0,
              divisions: 50,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(cvDiffValue: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Features to ignore
            TextFormField(
              initialValue: fs.featuresToIgnore.join(', '),
              decoration: const InputDecoration(
                labelText: 'Игнорируемые фичи',
                border: OutlineInputBorder(),
                hintText: 'feature1, feature2, feature3',
              ),
              onChanged: (value) {
                final features = value.split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(featuresToIgnore: features),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Use temp data switch
            SwitchListTile(
              title: const Text('Использовать сохраненные данные'),
              value: fs.useTempData,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    featureSelection: fs.copyWith(useTempData: value),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHPTuningSection() {
    final hp = _config.hpTune;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hyperparameter Tuning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: hp.sampling,
              decoration: const InputDecoration(
                labelText: 'Сэмплинг метод',
                border: OutlineInputBorder(),
                hintText: 'TPE, Random, Grid',
              ),
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    hpTune: hp.copyWith(sampling: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: hp.cvFoldsNum.toString(),
              decoration: const InputDecoration(
                labelText: 'CV Folds',
                border: OutlineInputBorder(),
                hintText: '3',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _config = _config.copyWith(
                      hpTune: hp.copyWith(
                        cvFoldsNum: int.tryParse(value) ?? 3,
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInferenceSection() {
    final ic = _config.inferenceCriteria;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Model Inference',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: ic.prodModelsFolder,
              decoration: const InputDecoration(
                labelText: 'Папка моделей *',
                border: OutlineInputBorder(),
                hintText: '/path/to/models',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, укажите путь к моделям';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    inferenceCriteria: ic.copyWith(prodModelsFolder: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: ic.prodPath,
              decoration: const InputDecoration(
                labelText: 'Продакшен путь (опционально)',
                border: OutlineInputBorder(),
                hintText: '/path/to/production',
              ),
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    inferenceCriteria: ic.copyWith(prodPath: value.isEmpty ? null : value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Calculate Threshold
            DropdownButtonFormField<int>(
              value: ic.calculateThreshold,
              decoration: const InputDecoration(
                labelText: 'Рассчитывать порог',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Нет')),
                DropdownMenuItem(value: 1, child: Text('Да')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(
                      inferenceCriteria: ic.copyWith(calculateThreshold: value),
                    );
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Threshold values
            const Text('Пороговые значения:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: ic.threshold[0],
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    label: ic.threshold[0].toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() {
                        final newThreshold = List<double>.from(ic.threshold);
                        newThreshold[0] = value;
                        _config = _config.copyWith(
                          inferenceCriteria: ic.copyWith(threshold: newThreshold),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: ic.threshold[1],
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    label: ic.threshold[1].toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() {
                        final newThreshold = List<double>.from(ic.threshold);
                        newThreshold[1] = value;
                        _config = _config.copyWith(
                          inferenceCriteria: ic.copyWith(threshold: newThreshold),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Threshold 1: ${ic.threshold[0].toStringAsFixed(2)}'),
                Text('Threshold 2: ${ic.threshold[1].toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class AllModelsConfigEditor extends StatefulWidget {
  final AllModelsConfig initialConfig;
  final Function(AllModelsConfig)? onSave;
  
  const AllModelsConfigEditor({
    super.key,
    required this.initialConfig,
    this.onSave,
  });
  
  @override
  _AllModelsConfigEditorState createState() => _AllModelsConfigEditorState();
}

class _AllModelsConfigEditorState extends State<AllModelsConfigEditor> {
  late AllModelsConfig _config;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _saveError;
  
  // Опции для источников данных
  final List<String> _sourceOptions = [
    "data_init", "parquet", "database", "pickle", "csv", "hadoop",
  ];
  
  // Опции для стратегий разделения
  final List<String> _separationKindOptions = ["random", "date", "none"];
  
  // Опции для энкодинга
  final List<String> _encodingOptions = [
    "WoE_num_to_cat", "WoE_cat_to_num", "to_float", 
    "to_int", "WoE_num_to_num", "cut_num",
  ];
  
  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }
  
  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSaving = true;
      _saveError = null;
    });
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (widget.onSave != null) {
        widget.onSave!(_config);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Конфигурация успешно сохранена!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, _config);
    } catch (e) {
      setState(() {
        _saveError = e.toString();
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать AllModels конфигурацию'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveConfig,
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: _buildEditorForm(),
    );
  }
  
  Widget _buildEditorForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Основная информация
            buildBasicInfoSection(
              config: _config,
              onConfigChanged: (config) {
                setState(() => _config = config);
              },
            ),
            const SizedBox(height: 24),
            
            // Конфигурация данных
            AllModelsDataConfigSection(
              dataConfig: _config.dataConfig,
              onDataConfigChanged: (dataConfig) {
                setState(() {
                  _config = _config.copyWith(dataConfig: dataConfig);
                });
              },
              sourceOptions: _sourceOptions,
              separationKindOptions: _separationKindOptions,
            ),
            const SizedBox(height: 24),
            
            // Модели
            buildModelsInfoSection(
              models: _config.modelsConfigs,
              onEditModel: _editModel,
              onAddModel: _addNewModel,
              onEditFeature: _editFeature,
              onAddFeature: _addFeature,
            ),
            const SizedBox(height: 24),
            
            // Ошибка сохранения
            if (_saveError != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(child: Text(_saveError!)),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 32),
            
            // Кнопки сохранения
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveConfig,
                    icon: _isSaving 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSaving ? 'Сохранение...' : 'Сохранить'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _editModel(int index) {
    final model = _config.modelsConfigs[index];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: buildModelEditForm(
              model: model,
              modelIndex: index,
              onModelChanged: (updatedModel) {
                final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                updatedModels[index] = updatedModel;
                setState(() {
                  _config = _config.copyWith(modelsConfigs: updatedModels);
                });
              },
              onAddFeature: _addFeature,
              onEditFeature: _editFeature,
            ),
          );
        },
      ),
    );
  }
  
  void _addNewModel() {
    final newModel = ModelConfig(
      name: 'Новая модель ${_config.modelsConfigs.length + 1}',
      objective: 'binary',
      wrapper: 'glm',
      relativeFeatures: const [],
      features: [],
    );
    
    setState(() {
      final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
      updatedModels.add(newModel);
      _config = _config.copyWith(modelsConfigs: updatedModels);
    });
    
    _editModel(_config.modelsConfigs.length - 1);
  }
  
  void _addFeature(int modelIndex) {
    final newFeature = FeatureModelConfig(
      name: 'Новая фича',
      defaultValue: '',
      replace: {},
    );
    
    setState(() {
      final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
      final model = updatedModels[modelIndex];
      final updatedFeatures = List<FeatureModelConfig>.from(model.features);
      updatedFeatures.add(newFeature);
      
      updatedModels[modelIndex] = model.copyWith(features: updatedFeatures);
      _config = _config.copyWith(modelsConfigs: updatedModels);
    });
    
    _editFeature(modelIndex, _config.modelsConfigs[modelIndex].features.length - 1);
  }
  
  void _editFeature(int modelIndex, int featureIndex) {
    final model = _config.modelsConfigs[modelIndex];
    final feature = model.features[featureIndex];
    
    showDialog(
      context: context,
      builder: (context) => FeatureEditorDialog(
        feature: feature,
        encodingOptions: _encodingOptions,
        onFeatureSaved: (updatedFeature) {
          final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
          final updatedFeatures = List<FeatureModelConfig>.from(
            updatedModels[modelIndex].features,
          );
          updatedFeatures[featureIndex] = updatedFeature;
          
          updatedModels[modelIndex] = updatedModels[modelIndex]
              .copyWith(features: updatedFeatures);
          
          setState(() {
            _config = _config.copyWith(modelsConfigs: updatedModels);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Фича обновлена')),
          );
        },
      ),
    );
  }
}