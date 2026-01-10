import 'dart:convert';

import 'package:ml_app/infrastructure/config_data.dart';
import 'package:ml_app/presentation/data/widgets/config_editors.dart';
import 'package:ml_app/presentation/core/widgets/compact_config_form.dart';
import 'package:ml_app/presentation/core/widgets/config_view_toggle.dart';
import 'package:ml_app/presentation/core/widgets/config_json_preview.dart';
import 'package:ml_app/presentation/core/widgets/config_view_mode.dart';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';



///
class ConfigDataBody extends StatefulWidget {
  final ConfigData configData;
  
  const ConfigDataBody({
    Key? key,
    required this.configData,
  }) : super(key: key);
  
  @override
  State<ConfigDataBody> createState() => _ConfigDataBodyState();
}

class _ConfigDataBodyState extends State<ConfigDataBody> {
  AutoMLConfig? _config;
  AllModelsConfig? _allModelsConfig;
  bool _isLoading = false;
  String? _error;
  ConfigViewMode _currentMode = ConfigViewMode.autoML;
  @override
  void initState() {
    super.initState();
    _loadConfig();
  }
  
  Future<void> _loadConfig() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    final result = await widget.configData.getAutoMLConfig();
    final result2 = await widget.configData.getAllModelsConfig();
    result.fold(
      onData: (config) {
        if (mounted) {
          setState(() {
            _config = config;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.message;
            _isLoading = false;
          });
        }
      },
    );
    result2.fold(
      onData: (config) {
        if (mounted) {
          setState(() {
            _allModelsConfig = config;
            _isLoading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.message;
            _isLoading = false;
          });
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Ошибка:', style: Theme.of(context).textTheme.titleMedium),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadConfig,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }
    
    if (_config == null) {
      return const Center(child: Text('Нет данных конфигурации'));
    }
    
    return _buildCombinedViewWithToggle();//_buildCompactAllModelsConfigForm(_allModelsConfig!);
  }
  Widget _buildCombinedViewWithToggle() {
  return Column(
      children: [
        ConfigViewToggle(
          currentMode: _currentMode,
          onModeChanged: (mode) {
            setState(() {
              _currentMode = mode;
            });
          },
          modelsCount: _allModelsConfig?.modelsConfigs.length,
        ),
        
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentMode == ConfigViewMode.autoML
                ? CompactConfigForm(
                    config: _config!,
                    onShowJson: () => ConfigJsonPreview.showAutoMLJsonPreview(context, _config!),
                    onEdit: _openEditor,
                  )
                : CompactAllModelsConfigForm(
                    config: _allModelsConfig!,
                    onShowJson: () => ConfigJsonPreview.showAllModelsJsonPreview(context, _allModelsConfig!),
                    onEdit: _openModelEditor,
                  ),
          ),
        ),
      ],
    );
  }
void _openEditor() async {
  final updatedConfig = await Navigator.push<AutoMLConfig?>(
    context,
    MaterialPageRoute(
      builder: (context) => AutoMLConfigEditor(
        initialConfig: _config!,
      ),
    ),
  );
  
  // 2. Проверяем, вернулись ли новые данные
  if (updatedConfig != null && mounted) {
    // 3. Обновляем состояние с новыми данными
    setState(() {
      _config = updatedConfig; // <- Обновляем _config
    });
  }
}
void _openModelEditor() async {
  final updatedConfig = await Navigator.push<AllModelsConfig?>(
    context,
    MaterialPageRoute(
      builder: (context) => AllModelsConfigEditor(
        initialConfig: _allModelsConfig!,
      ),
    ),
  );
  
  // 2. Проверяем, вернулись ли новые данные
  if (updatedConfig != null && mounted) {
    // 3. Обновляем состояние с новыми данными
    setState(() {
      _allModelsConfig = updatedConfig; // <- Обновляем _config
    });
  }
}




}