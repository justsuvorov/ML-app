import 'dart:convert';

import 'package:ml_app/domain/core/entities/core_entitie.dart';
import 'package:uuid/uuid.dart';

import 'package:http/http.dart' as http;


abstract class ApiQueryType {
  bool valid();
  String buildJson();
  String get authToken;
  String get id;
}

class FastApiQuery implements ApiQueryType {
  final String _baseUrl;
  final String _authToken = 'None';
  late String _id;

  FastApiQuery({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  @override
  bool valid() {
    return true;
  }

  @override
  String buildJson() {
    _id = const Uuid().v1();
    final jsonString = json.encode({
      'auth_token': _authToken,
      'id': _id,
      'status': 'status',
    });
    return jsonString;
  }

  @override
  String get authToken => _authToken;

  @override
  String get id => _id;

  Future<AutoMLConfig> getAutoMLDefaultConfig() async {    
    try {
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/default_automl_config'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AutoMLConfig.fromJson(jsonData);
      } else {
        throw Exception('Failed to load default config: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
Future<AllModelsConfig> getAllModelsDefaultConfig() async {    
    try {
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/default_all_models_config'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AllModelsConfig.fromJson(jsonData);
      } else {
        throw Exception('Failed to load default config: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
Future<Map<String, dynamic>> updateRequest({
  required AutoMLConfig autoMLConfig,
  required AllModelsConfig allModelsConfig,
  bool retro = true,
  bool hpTune = false,
  bool useTempFiles = false,
}) async {
  try {
    final Map<String, dynamic> requestData = {
      'auto_ml_config': _removeNulls(autoMLConfig.toJson()),
      'all_model_config': _removeNulls(allModelsConfig.toJson()),
      'user_parameters': {
        'retro': retro,
        'hp_tune': hpTune,
        'use_temp_files': useTempFiles,
      },
    };

    print('Sending cleaned request: ${jsonEncode(requestData)}');

    final response = await http.post(
      Uri.parse('$_baseUrl/api/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update models: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Network error in updateRequest: $e');
    rethrow;
  }
}

// Вспомогательная функция для удаления null значений
Map<String, dynamic> _removeNulls(Map<String, dynamic> json) {
  final Map<String, dynamic> cleaned = {};
  
  for (final entry in json.entries) {
    if (entry.value != null) {
      if (entry.value is Map<String, dynamic>) {
        cleaned[entry.key] = _removeNulls(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        // Обработка списков
        final list = (entry.value as List).map((item) {
          if (item is Map<String, dynamic>) {
            return _removeNulls(item);
          }
          return item;
        }).toList();
        cleaned[entry.key] = list;
      } else {
        cleaned[entry.key] = entry.value;
      }
    }
    // Игнорируем null значения
  }
  
  return cleaned;
}
}