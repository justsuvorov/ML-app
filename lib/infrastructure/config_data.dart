import 'package:ml_app/domain/core/error/failure.dart';
import 'package:ml_app/domain/core/result/result.dart';
import 'package:ml_app/infrastructure/api_query_type/fast_api_query.dart';
import 'package:logging/logging.dart';
import 'package:ml_app/domain/core/entities/core_entitie.dart';

class ConfigData {
  final _log = Logger('ConfigData');
  final FastApiQuery _fastAPIQuery;
  
  ConfigData({
    required FastApiQuery fastAPIQuery,
  }) : _fastAPIQuery = fastAPIQuery;
  
  Future<Result<AutoMLConfig>> getAutoMLConfig() async {
    try {
      _log.fine('Fetching AutoML config from API...');
      
      if (!_fastAPIQuery.valid()) {
        return Result<AutoMLConfig>(
          error: Failure(
            message: 'API query validation failed',
            stackTrace: StackTrace.current,
          ),
        );
      }
      
      final config = await _fastAPIQuery.getAutoMLDefaultConfig();
      _log.fine('Config received: ${config.project}');
      
      return Result<AutoMLConfig>(data: config);
      
    } catch (e, stackTrace) {
      _log.severe('Error fetching AutoML config: $e', e, stackTrace);
      return Result<AutoMLConfig>(
        error: Failure(
          message: 'Error fetching config: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<Result<AllModelsConfig>> getAllModelsConfig() async {
    try {
      _log.fine('Fetching AllModels config from API...');
      
       if (!_fastAPIQuery.valid()) {
        return Result<AllModelsConfig>(
          error: Failure(
            message: 'API query validation failed',
            stackTrace: StackTrace.current,
          ),
        );
      }
      
      final models_config = await _fastAPIQuery.getAllModelsDefaultConfig();
      _log.fine('Config received: ${models_config.project}');
      
      return Result<AllModelsConfig>(data: models_config);
      
    } catch (e, stackTrace) {
      _log.severe('Error fetching AutoML config: $e', e, stackTrace);
      return Result<AllModelsConfig>(
        error: Failure(
          message: 'Error fetching config: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }
  
  // Метод all() который возвращает List<Map>
  Future<Result<List<Map<String, dynamic>>>> all() async {
    try {
      if (!_fastAPIQuery.valid()) {
        return Result<List<Map<String, dynamic>>>(
          error: Failure(
            message: 'SQL query is empty',
            stackTrace: StackTrace.current,
          ),
        );
      }
      
      final result = await _fastAPIQuery.getAutoMLDefaultConfig();
      final modelConfigResult = await _fastAPIQuery.getAllModelsDefaultConfig();

      final listData = [
      result.toJson(),
      modelConfigResult.toJson(),
      ];
      return Result<List<Map<String, dynamic>>>(data: listData);
      
    } catch (e, stackTrace) {
      _log.severe('Error in ConfigData.all(): $e', e, stackTrace);
      return Result<List<Map<String, dynamic>>>(
        error: Failure(
          message: '[ConfigData.all] error: $e',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<Result<AutoMLConfig>> saveAutoMLConfig(AutoMLConfig config) async {
  try {
    
    return Result<AutoMLConfig>(data: config);
  } catch (e, stackTrace) {
    _log.severe('Error saving AutoML config: $e', e, stackTrace);
    return Result<AutoMLConfig>(
      error: Failure(
        message: 'Error saving config: $e',
        stackTrace: stackTrace,
      ),
    );
  }
}

  Future<Result<AllModelsConfig>> saveAllModelsConfig(AllModelsConfig config) async {
  try {
    
    return Result<AllModelsConfig>(data: config);
  } catch (e, stackTrace) {
    _log.severe('Error saving AutoML config: $e', e, stackTrace);
    return Result<AllModelsConfig>(
      error: Failure(
        message: 'Error saving config: $e',
        stackTrace: stackTrace,
      ),
    );
  }
}
}