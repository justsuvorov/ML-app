import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/shared_widgets.dart';

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
  
  // Опции для источников данных (FilesNames enum)
  final List<String> _sourceOptions = [
    "data_init",
    "parquet", 
    "database",
    "pickle",
    "csv",
    "hadoop"
  ];
  
  // Опции для Objective
  final List<String> _objectiveOptions = [
    "poisson",
    "gamma", 
    "binary",
    "RMSE",
    "rmsewithuncertainty",
  ];
  
  // Опции для Wrapper
  final List<String> _wrapperOptions = [
    "glm",
    "glm_without_scaler",
    "catboost", 
    "catboost_over_glm",
    "xgboost",
  ];
  
  // Опции для стратегий разделения (SeparationParams enum)
  final List<String> _separationKindOptions = [
    "random",  // было "rand"
    "date",    // было "period" 
    "none"     // было "null"
  ];
  
  // Опции для энкодинга (EncodingNames enum)
  final List<String> _encodingOptions = [
    "WoE_num_to_cat",
    "WoE_cat_to_num", 
    "to_float",
    "to_int",
    "WoE_num_to_num",
    "cut_num"
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
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            
            // Конфигурация данных
            _buildDataConfigSection(),
            const SizedBox(height: 24),
            
            // Модели (показываем только количество)
            _buildModelsInfoSection(),
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
              initialValue: _config.version,
              decoration: const InputDecoration(
                labelText: 'Версия *',
                border: OutlineInputBorder(),
                hintText: 'Введите версию',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите версию';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(version: value);
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            TextFormField(
              initialValue: _config.groupName,
              decoration: const InputDecoration(
                labelText: 'Группа моделей*',
                border: OutlineInputBorder(),
                hintText: 'Введите название группы моделей',
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
            
            // Информация о количестве моделей
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gas_meter_sharp, color: Colors.blue),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Количество моделей в ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${_config.modelsConfigs.length} моделей',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDataConfigSection() {
    final dataConfig = _config.dataConfig;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Конфигурация данных',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Источник данных
            DropdownButtonFormField<String>(
              value: dataConfig.source,
              decoration: const InputDecoration(
                labelText: 'Источник данных *',
                border: OutlineInputBorder(),
              ),
              items: _sourceOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, выберите источник данных';
                }
                return null;
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _config = _config.copyWith(
                      dataConfig: dataConfig.copyWith(source: value),
                    );
                  });
                }
              },
            ),
            
            const SizedBox(height: 12),
            
            // Имя таблицы
            TextFormField(
              initialValue: dataConfig.tableNameSource,
              decoration: const InputDecoration(
                labelText: 'Имя таблицы',
                border: OutlineInputBorder(),
                hintText: 'Введите имя таблицы',
              ),
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    dataConfig: dataConfig.copyWith(tableNameSource: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            // Локальное имя файла
            TextFormField(
              initialValue: dataConfig.localNameSource,
              decoration: const InputDecoration(
                labelText: 'Локальное имя файла',
                border: OutlineInputBorder(),
                hintText: 'Путь к локальному файлу',
              ),
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    dataConfig: dataConfig.copyWith(localNameSource: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 12),

            
            // Показ графиков
            SwitchListTile(
              title: const Text('Показ графиков'),
              value: dataConfig.showGraphs ?? false,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    dataConfig: dataConfig.copyWith(showGraphs: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 12),
            
            // Дополнительные условия
            TextFormField(
              initialValue: dataConfig.extraConditions,
              decoration: const InputDecoration(
                labelText: 'Дополнительные условия',
                border: OutlineInputBorder(),
                hintText: 'SQL условия для фильтрации',
              ),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _config = _config.copyWith(
                    dataConfig: dataConfig.copyWith(extraConditions: value),
                  );
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Разделение данных
            _buildSeparationSection(),
            
            const SizedBox(height: 16),
            
            // Дополнительные колонки
            TextFormField(
              initialValue: dataConfig.extraColumns?.join(', '),
              decoration: const InputDecoration(
                labelText: 'Дополнительные поля',
                border: OutlineInputBorder(),
                hintText: 'col1, col2, col3',
              ),
              onChanged: (value) {
                final columns = value.split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
                setState(() {
                  _config = _config.copyWith(
                    dataConfig: dataConfig.copyWith(extraColumns: columns),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSeparationSection() {
    final dataConfig = _config.dataConfig;
    final separation = dataConfig.separation;
    
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
              setState(() {
                _config = _config.copyWith(
                  dataConfig: dataConfig.copyWith(
                    separation: SeparationModelConfig(
                      kind: 'random', // Значение по умолчанию
                      randomState: 42,
                      testTrainProportion: 0.3,
                    ),
                  ),
                );
              });
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
                setState(() {
                  _config = _config.copyWith(
                    dataConfig: dataConfig.copyWith(separation: null),
                  );
                });
              },
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
        
        // Тип разделения
        DropdownButtonFormField<String>(
          value: separation.kind,
          decoration: const InputDecoration(
            labelText: 'Тип разделения',
            border: OutlineInputBorder(),
          ),
          items: _separationKindOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _config = _config.copyWith(
                  dataConfig: dataConfig.copyWith(
                    separation: separation.copyWith(kind: value),
                  ),
                );
              });
            }
          },
        ),
        
        const SizedBox(height: 12),
        
        // Random State
        TextFormField(
          initialValue: separation.randomState?.toString(),
          decoration: const InputDecoration(
            labelText: 'Random State',
            border: OutlineInputBorder(),
            hintText: '42',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _config = _config.copyWith(
                dataConfig: dataConfig.copyWith(
                  separation: separation.copyWith(
                    randomState: int.tryParse(value),
                  ),
                ),
              );
            });
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
            setState(() {
              _config = _config.copyWith(
                dataConfig: dataConfig.copyWith(
                  separation: separation.copyWith(testTrainProportion: value),
                ),
              );
            });
          },
        ),
        
        const SizedBox(height: 12),
        
        // Периоды для обучения и тестирования
        if (separation.kind == 'date') ...[
          TextFormField(
            initialValue: separation.trainPeriod?.join(', '),
            decoration: const InputDecoration(
              labelText: 'Период обучения',
              border: OutlineInputBorder(),
              hintText: '2023-01-01, 2023-06-30',
            ),
            onChanged: (value) {
              final periods = value.split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              setState(() {
                _config = _config.copyWith(
                  dataConfig: dataConfig.copyWith(
                    separation: separation.copyWith(trainPeriod: periods),
                  ),
                );
              });
            },
          ),
          
          const SizedBox(height: 12),
          
          TextFormField(
            initialValue: separation.testPeriod?.join(', '),
            decoration: const InputDecoration(
              labelText: 'Период тестирования',
              border: OutlineInputBorder(),
              hintText: '2023-07-01, 2023-12-31',
            ),
            onChanged: (value) {
              final periods = value.split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              setState(() {
                _config = _config.copyWith(
                  dataConfig: dataConfig.copyWith(
                    separation: separation.copyWith(testPeriod: periods),
                  ),
                );
              });
            },
          ),
          
          const SizedBox(height: 12),
          
          TextFormField(
            initialValue: separation.periodColumn?.join(', '),
            decoration: const InputDecoration(
              labelText: 'Колонки периода',
              border: OutlineInputBorder(),
              hintText: 'date_column',
            ),
            onChanged: (value) {
              final columns = value.split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              setState(() {
                _config = _config.copyWith(
                  dataConfig: dataConfig.copyWith(
                    separation: separation.copyWith(periodColumn: columns),
                  ),
                );
              });
            },
          ),
        ],
      ],
    );
  }
  
  Widget _buildModelsInfoSection() {
    final models = _config.modelsConfigs;
    
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
                        Text('Цель: ${model.objective ?? "не указана"}'),
                        Text('Модель: ${model.wrapper ?? "не указана"}'),
                        Text('Фичи: $featureCount основных, $relativeFeatureCount относительных'),
                        if (model.columnTarget != null)
                          Text('Таргет: ${model.columnTarget}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showModelDetails(model, index);
                    },
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Кнопка для добавления/редактирования моделей
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showModelsManagement();
                },
                icon: const Icon(Icons.edit),
                label: const Text('Управление моделями'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showModelDetails(ModelConfig model, int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Модель: ${model.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Название', model.name),
              _buildDetailRow('Objective', model.objective ?? '—'),
              _buildDetailRow('Wrapper', model.wrapper ?? '—'),
              _buildDetailRow('Таргет', model.columnTarget ?? '—'),
              _buildDetailRow('Колонка экспозиции', model.columnExposure ?? '—'),
              _buildDetailRow('Количество фичей', '${model.features.length}'),
              _buildDetailRow('Относительные фичи', '${model.relativeFeatures.length}'),
              _buildDetailRow('Условие фильтрации', model.dataFilterCondition ?? '—'),
              
              if (model.paramsCatboost != null && model.paramsCatboost!.isNotEmpty)
                _buildDetailRow('Параметры CatBoost', '${model.paramsCatboost!.length} параметров'),
              
              if (model.paramsXgb != null && model.paramsXgb!.isNotEmpty)
                _buildDetailRow('Параметры XGBoost', '${model.paramsXgb!.length} параметров'),
              
              if (model.paramsGlm != null && model.paramsGlm!.isNotEmpty)
                _buildDetailRow('Параметры GLM', '${model.paramsGlm!.length} параметров'),
              
              if (model.catFeaturesCatboost != null)
                _buildDetailRow('Категориальные фичи', model.catFeaturesCatboost!.join(', ')),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _editModelDialog(index);
          },
          child: const Text('Редактировать'),
        ),
      ],
    ),
  );
}

void _editModelDialog(int index) {
  final model = _config.modelsConfigs[index];
  
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        ModelConfig editingModel = model;
        
        return AlertDialog(
          title: Text('Редактировать модель: ${model.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                updatedModels[index] = editingModel;
                setState(() {
                  _config = _config.copyWith(modelsConfigs: updatedModels);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Модель обновлена')),
                );
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    ),
  );
}
  Widget _buildDetailRow(String label, String value) {
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
  
  Widget _buildDropdownRow({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
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
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: Container(height: 1, color: Colors.grey[300]),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('—', style: TextStyle(color: Colors.grey)),
                ),
                ...options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditableRow({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
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
            child: TextFormField(
              initialValue: value,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showModelsManagement() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Управление моделями'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Добавить новую модель'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewModel();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Редактировать список моделей'),
                onTap: () {
                  Navigator.pop(context);
                  _showModelsList();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }
  
  
void _editModel(int index) {
    final model = _config.modelsConfigs[index];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _buildModelEditForm(model, index),
      ),
    );
  }
  
  Widget _buildModelEditForm(ModelConfig model, int index) {
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
          TextFormField(
            initialValue: model.name,
            decoration: const InputDecoration(
              labelText: 'Название модели *',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
              updatedModels[index] = updatedModels[index].copyWith(name: value);
              _config = _config.copyWith(modelsConfigs: updatedModels);
              setState(() {});
            },
          ),
          
          const SizedBox(height: 12),
          
          // Objective
          TextFormField(
            initialValue: model.objective ?? '',
            decoration: const InputDecoration(
              labelText: 'Objective',
              border: OutlineInputBorder(),
              hintText: 'poisson, gamma, binary, RMSE, rmsewithuncertainty',
            ),
            onChanged: (value) {
              final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
              updatedModels[index] = updatedModels[index].copyWith(
                objective: value.isEmpty ? null : value,
              );
              _config = _config.copyWith(modelsConfigs: updatedModels);
              setState(() {});
            },
          ),
          
          const SizedBox(height: 12),
          
          // Wrapper
          TextFormField(
            initialValue: model.wrapper ?? '',
            decoration: const InputDecoration(
              labelText: 'Wrapper',
              border: OutlineInputBorder(),
              hintText: 'glm, glm_without_scaler, catboost, catboost_over_glm, xgboost',
            ),
            onChanged: (value) {
              final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
              updatedModels[index] = updatedModels[index].copyWith(
                wrapper: value.isEmpty ? null : value,
              );
              _config = _config.copyWith(modelsConfigs: updatedModels);
              setState(() {});
            },
          ),
          
          const SizedBox(height: 12),
          
          // Целевая колонка
          TextFormField(
            initialValue: model.columnTarget ?? '',
            decoration: const InputDecoration(
              labelText: 'Целевая колонка',
              border: OutlineInputBorder(),
              hintText: 'target_column',
            ),
            onChanged: (value) {
              final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
              updatedModels[index] = updatedModels[index].copyWith(
                columnTarget: value.isEmpty ? null : value,
              );
              _config = _config.copyWith(modelsConfigs: updatedModels);
              setState(() {});
            },
          ),
          
          const SizedBox(height: 12),
          
          // Колонка экспозиции
          TextFormField(
            initialValue: model.columnExposure ?? '',
            decoration: const InputDecoration(
              labelText: 'Колонка экспозиции',
              border: OutlineInputBorder(),
              hintText: 'exposure_column',
            ),
            onChanged: (value) {
              final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
              updatedModels[index] = updatedModels[index].copyWith(
                columnExposure: value.isEmpty ? null : value,
              );
              _config = _config.copyWith(modelsConfigs: updatedModels);
              setState(() {});
            },
          ),
          
          const SizedBox(height: 12),
          
          // Условие фильтрации
          TextFormField(
            initialValue: model.dataFilterCondition ?? '',
            decoration: const InputDecoration(
              labelText: 'Условие фильтрации',
              border: OutlineInputBorder(),
              hintText: 'WHERE condition',
            ),
            maxLines: 2,
            onChanged: (value) {
              final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
              updatedModels[index] = updatedModels[index].copyWith(
                dataFilterCondition: value.isEmpty ? null : value,
              );
              _config = _config.copyWith(modelsConfigs: updatedModels);
              setState(() {});
            },
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
                    onPressed: () => _editFeature(index, featureIndex),
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
              onPressed: () => _addFeature(index),
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
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
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
    
    // Показываем диалог редактирования новой модели
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
    
    // Показываем диалог редактирования новой фичи
    _editFeature(modelIndex, _config.modelsConfigs[modelIndex].features.length - 1);
  }
  
  void _editFeature(int modelIndex, int featureIndex) {
    final model = _config.modelsConfigs[modelIndex];
    final feature = model.features[featureIndex];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редактировать фичу'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Название фичи
                TextFormField(
                  initialValue: feature.name,
                  decoration: const InputDecoration(
                    labelText: 'Название фичи *',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                    final updatedFeatures = List<FeatureModelConfig>.from(
                      updatedModels[modelIndex].features,
                    );
                    updatedFeatures[featureIndex] = updatedFeatures[featureIndex]
                        .copyWith(name: value);
                    
                    updatedModels[modelIndex] = updatedModels[modelIndex]
                        .copyWith(features: updatedFeatures);
                    _config = _config.copyWith(modelsConfigs: updatedModels);
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Значение по умолчанию
                TextFormField(
                  initialValue: feature.defaultValue?.toString() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Значение по умолчанию',
                    border: OutlineInputBorder(),
                    hintText: '0, 1.0, "значение"',
                  ),
                  onChanged: (value) {
                    final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                    final updatedFeatures = List<FeatureModelConfig>.from(
                      updatedModels[modelIndex].features,
                    );
                    updatedFeatures[featureIndex] = updatedFeatures[featureIndex]
                        .copyWith(defaultValue: value);
                    
                    updatedModels[modelIndex] = updatedModels[modelIndex]
                        .copyWith(features: updatedFeatures);
                    _config = _config.copyWith(modelsConfigs: updatedModels);
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Энкодинг
                DropdownButtonFormField<String?>(
                  value: feature.encoding,
                  decoration: const InputDecoration(
                    labelText: 'Энкодинг',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Не указан'),
                    ),
                    ..._encodingOptions.map((option) {
                      return DropdownMenuItem<String?>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                    final updatedFeatures = List<FeatureModelConfig>.from(
                      updatedModels[modelIndex].features,
                    );
                    updatedFeatures[featureIndex] = updatedFeatures[featureIndex]
                        .copyWith(encoding: value);
                    
                    updatedModels[modelIndex] = updatedModels[modelIndex]
                        .copyWith(features: updatedFeatures);
                    _config = _config.copyWith(modelsConfigs: updatedModels);
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Заполнение NaN
                TextFormField(
                  initialValue: feature.fillna?.toString() ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Заполнение NaN',
                    border: OutlineInputBorder(),
                    hintText: '0, "значение"',
                  ),
                  onChanged: (value) {
                    final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                    final updatedFeatures = List<FeatureModelConfig>.from(
                      updatedModels[modelIndex].features,
                    );
                    updatedFeatures[featureIndex] = updatedFeatures[featureIndex]
                        .copyWith(fillna: value.isEmpty ? null : value);
                    
                    updatedModels[modelIndex] = updatedModels[modelIndex]
                        .copyWith(features: updatedFeatures);
                    _config = _config.copyWith(modelsConfigs: updatedModels);
                    setState(() {});
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Cut Number
                TextFormField(
                  initialValue: feature.cutNumber ?? '',
                  decoration: const InputDecoration(
                    labelText: 'Cut Number',
                    border: OutlineInputBorder(),
                    hintText: 'например: 10',
                  ),
                  onChanged: (value) {
                    final updatedModels = List<ModelConfig>.from(_config.modelsConfigs);
                    final updatedFeatures = List<FeatureModelConfig>.from(
                      updatedModels[modelIndex].features,
                    );
                    updatedFeatures[featureIndex] = updatedFeatures[featureIndex]
                        .copyWith(cutNumber: value.isEmpty ? null : value);
                    
                    updatedModels[modelIndex] = updatedModels[modelIndex]
                        .copyWith(features: updatedFeatures);
                    _config = _config.copyWith(modelsConfigs: updatedModels);
                    setState(() {});
                  },
                ),
              ],
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

  
  void _showModelsList() {
    // Здесь будет отображение полного списка моделей с возможностью редактирования
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Редактирование списка моделей - в разработке')),
    );
  }
}