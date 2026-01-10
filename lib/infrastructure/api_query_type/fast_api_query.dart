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

}
