import 'package:flutter/material.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:ml_app/presentation/core/widgets/config_editors/all_models_config_editor.dart';
import 'package:ml_app/presentation/core/widgets/shared_widgets.dart';


class FeatureEditorDialog extends StatefulWidget {
  final FeatureModelConfig feature;
  final Function(FeatureModelConfig) onFeatureSaved;
  final List<String> encodingOptions;
  
  const FeatureEditorDialog({
    super.key,
    required this.feature,
    required this.onFeatureSaved,
    required this.encodingOptions,
  });
  
  @override
  _FeatureEditorDialogState createState() => _FeatureEditorDialogState();
}

class _FeatureEditorDialogState extends State<FeatureEditorDialog> {
  late FeatureModelConfig _editingFeature;
  
  @override
  void initState() {
    super.initState();
    _editingFeature = widget.feature;
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать фичу'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Название фичи
              buildFormField(
                label: 'Название фичи',
                initialValue: _editingFeature.name,
                isRequired: true,
                onChanged: (value) {
                  setState(() {
                    _editingFeature = _editingFeature.copyWith(name: value);
                  });
                },
              ),
              
              const SizedBox(height: 12),
              
              // Значение по умолчанию
              buildFormField(
                label: 'Значение по умолчанию',
                initialValue: _editingFeature.defaultValue?.toString() ?? '',
                hintText: '0, 1.0, "значение"',
                onChanged: (value) {
                  setState(() {
                    _editingFeature = _editingFeature.copyWith(defaultValue: value);
                  });
                },
              ),
              
              const SizedBox(height: 12),
              
              // Энкодинг
              buildDropdownField<String?>(
                label: 'Энкодинг',
                value: _editingFeature.encoding,
                options: [null, ...widget.encodingOptions],
                displayText: (option) => option ?? 'Не указан',
                onChanged: (value) {
                  setState(() {
                    _editingFeature = _editingFeature.copyWith(encoding: value);
                  });
                },
              ),
              
              const SizedBox(height: 12),
              
              // Заполнение NaN
              buildFormField(
                label: 'Заполнение NaN',
                initialValue: _editingFeature.fillna?.toString() ?? '',
                hintText: '0, "значение"',
                onChanged: (value) {
                  setState(() {
                    _editingFeature = _editingFeature.copyWith(
                      fillna: value.isEmpty ? null : value,
                    );
                  });
                },
              ),
              
              const SizedBox(height: 12),
              
              // Cut Number
              buildFormField(
                label: 'Cut Number',
                initialValue: _editingFeature.cutNumber ?? '',
                hintText: 'например: 10',
                onChanged: (value) {
                  setState(() {
                    _editingFeature = _editingFeature.copyWith(
                      cutNumber: value.isEmpty ? null : value,
                    );
                  });
                },
              ),
            ],
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
            widget.onFeatureSaved(_editingFeature);
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}