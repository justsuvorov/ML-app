import 'package:flutter/material.dart';
import 'package:ml_app/presentation/core/widgets/config_view_mode.dart';


class ConfigViewToggle extends StatelessWidget {
  final ConfigViewMode currentMode;
  final ValueChanged<ConfigViewMode> onModeChanged;
  final int? modelsCount;
  
  const ConfigViewToggle({
    Key? key,
    required this.currentMode,
    required this.onModeChanged,
    this.modelsCount,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: const Color.fromARGB(255, 221, 174, 174)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Переключатель
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color.fromARGB(255, 231, 182, 182)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Кнопка AutoML
                _buildToggleButton(
                  'AutoML',
                  ConfigViewMode.autoML,
                  Icons.auto_awesome,
                  Colors.blue,
                ),
                
                // Кнопка All Models
                _buildToggleButton(
                  'Models',
                  ConfigViewMode.allModels,
                  Icons.list_alt,
                  Colors.green,
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }
  
  Widget _buildToggleButton(
    String label,
    ConfigViewMode mode,
    IconData icon,
    Color activeColor,
  ) {
    final isActive = currentMode == mode;
    
    return Container(
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onModeChanged(mode),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}