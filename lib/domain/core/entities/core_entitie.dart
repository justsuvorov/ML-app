///
/// Core entity example
class CoreEntitie {

}

class AutoMLConfig {
  final String project;
  final String groupName;
  final FeatureSelectionConfig featureSelection;
  final HPTuneConfig hpTune;
  final ModelInferenceConfig inferenceCriteria;
  final String mlflowExperiment;
  final String grafanaTableName;
  final String dashboardName;
  final Map<String, String>? trigger;

  AutoMLConfig({
    required this.project,
    required this.groupName,
    required this.featureSelection,
    required this.hpTune,
    required this.inferenceCriteria,
    required this.mlflowExperiment,
    required this.grafanaTableName,
    required this.dashboardName,
    this.trigger,
  });

  factory AutoMLConfig.fromJson(Map<String, dynamic> json) {
    return AutoMLConfig(
      project: json['project'],
      groupName: json['group_name'],
      featureSelection: FeatureSelectionConfig.fromJson(json['feature_selection']),
      hpTune: HPTuneConfig.fromJson(json['hp_tune']),
      inferenceCriteria: ModelInferenceConfig.fromJson(json['inference_criteria']),
      mlflowExperiment: json['mlflow_experiment'],
      grafanaTableName: json['grafana_table_name'],
      dashboardName: json['dashboard_name'],
      trigger: json['trigger'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'group_name': groupName,
      'feature_selection': featureSelection.toJson(),
      'hp_tune': hpTune.toJson(),
      'inference_criteria': inferenceCriteria.toJson(),
      'mlflow_experiment': mlflowExperiment,
      'grafana_table_name': grafanaTableName,
      'dashboard_name': dashboardName,
      'trigger': trigger,
    };
  }
  AutoMLConfig copyWith({
    String? project,
    String? groupName,
    FeatureSelectionConfig? featureSelection,
    HPTuneConfig? hpTune,
    ModelInferenceConfig? inferenceCriteria,
    String? mlflowExperiment,
    String? grafanaTableName,
    String? dashboardName,
    Map<String, String>? trigger,
  }) {
    return AutoMLConfig(
      project: project ?? this.project,
      groupName: groupName ?? this.groupName,
      featureSelection: featureSelection ?? this.featureSelection,
      hpTune: hpTune ?? this.hpTune,
      inferenceCriteria: inferenceCriteria ?? this.inferenceCriteria,
      mlflowExperiment: mlflowExperiment ?? this.mlflowExperiment,
      grafanaTableName: grafanaTableName ?? this.grafanaTableName,
      dashboardName: dashboardName ?? this.dashboardName,
      trigger: trigger ?? this.trigger,
    );
  }
}

class FeatureSelectionConfig {
  final int topFeaturesToSelect;
  final int countCategory;
  final double cutoff1Category;
  final double cutoffNan;
  final double maxCorrValue;
  final Map<String, dynamic> metricEval;
  final double? cvDiffValue;  // Nullable
  final String encodingCat;
  final String encodingNum;
  final String defaultCat;
  final String defaultNum;
  final double depth;
  final List<String> featuresToIgnore;
  final Map<String, dynamic> params;
  final bool useTempData;

  FeatureSelectionConfig({
    required this.topFeaturesToSelect,
    required this.countCategory,
    required this.cutoff1Category,
    required this.cutoffNan,
    required this.maxCorrValue,
    required this.metricEval,
    this.cvDiffValue,  // Nullable
    required this.encodingCat,
    required this.encodingNum,
    required this.defaultCat,
    required this.defaultNum,
    required this.depth,
    required this.featuresToIgnore,
    required this.params,
    required this.useTempData,
  });

  factory FeatureSelectionConfig.fromJson(Map<String, dynamic> json) {
    return FeatureSelectionConfig(
      topFeaturesToSelect: json['top_features_to_select'] ?? 10,  // Default value
      countCategory: json['count_category'] ?? 100,
      cutoff1Category: (json['cutoff_1_category'] ?? 0.99).toDouble(),
      cutoffNan: (json['cutoff_nan'] ?? 0.7).toDouble(),
      maxCorrValue: (json['max_corr_value'] ?? 0.6).toDouble(),
      metricEval: json['metric_eval'] ?? {'metric_name': 0},
      cvDiffValue: json['cv_diff_value']?.toDouble(),  // Nullable
      encodingCat: json['encoding_cat'] ?? 'WoE_cat_to_num',
      encodingNum: json['encoding_num'] ?? 'WoE_num_to_num',
      defaultCat: json['default_cat'] ?? '_NAN_',
      defaultNum: json['default_num'] ?? '_MEDIAN_',
      depth: (json['depth'] ?? 0.01).toDouble(),
      featuresToIgnore: (json['features_to_ignore'] as List<dynamic>?)
          ?.cast<String>() 
          ?? [],  // Handle null
      params: json['params'] ?? {},
      useTempData: json['use_temp_data'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_features_to_select': topFeaturesToSelect,
      'count_category': countCategory,
      'cutoff_1_category': cutoff1Category,
      'cutoff_nan': cutoffNan,
      'max_corr_value': maxCorrValue,
      'metric_eval': metricEval,
      'cv_diff_value': cvDiffValue,
      'encoding_cat': encodingCat,
      'encoding_num': encodingNum,
      'default_cat': defaultCat,
      'default_num': defaultNum,
      'depth': depth,
      'features_to_ignore': featuresToIgnore,
      'params': params,
      'use_temp_data': useTempData,
    };
  }

  FeatureSelectionConfig copyWith({
    int? topFeaturesToSelect,
    int? countCategory,
    double? cutoff1Category,
    double? cutoffNan,
    double? maxCorrValue,
    Map<String, dynamic>? metricEval,
    double? cvDiffValue,
    String? encodingCat,
    String? encodingNum,
    String? defaultCat,
    String? defaultNum,
    double? depth,
    List<String>? featuresToIgnore,
    Map<String, dynamic>? params,
    bool? useTempData,
  }) {
    return FeatureSelectionConfig(
      topFeaturesToSelect: topFeaturesToSelect ?? this.topFeaturesToSelect,
      countCategory: countCategory ?? this.countCategory,
      cutoff1Category: cutoff1Category ?? this.cutoff1Category,
      cutoffNan: cutoffNan ?? this.cutoffNan,
      maxCorrValue: maxCorrValue ?? this.maxCorrValue,
      metricEval: metricEval ?? this.metricEval,
      cvDiffValue: cvDiffValue ?? this.cvDiffValue,
      encodingCat: encodingCat ?? this.encodingCat,
      encodingNum: encodingNum ?? this.encodingNum,
      defaultCat: defaultCat ?? this.defaultCat,
      defaultNum: defaultNum ?? this.defaultNum,
      depth: depth ?? this.depth,
      featuresToIgnore: featuresToIgnore ?? this.featuresToIgnore,
      params: params ?? this.params,
      useTempData: useTempData ?? this.useTempData,
    );
  }

}

class HPTuneConfig {
  final String sampling;
  final int cvFoldsNum;
  final Map<String, dynamic>? parameters;  // Nullable
  final Map<String, String>? metricScore;  // Nullable

  HPTuneConfig({
    required this.sampling,
    required this.cvFoldsNum,
    this.parameters,  // Nullable
    this.metricScore,  // Nullable
  });

  factory HPTuneConfig.fromJson(Map<String, dynamic> json) {
    return HPTuneConfig(
      sampling: json['sampling'] ?? 'TPE',
      cvFoldsNum: json['cv_folds_num'] ?? 3,
      parameters: json['parameters'],  // Может быть null
      metricScore: json['metric_score'] != null
          ? Map<String, String>.from(json['metric_score'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sampling': sampling,
      'cv_folds_num': cvFoldsNum,
      'parameters': parameters,
      'metric_score': metricScore,
    };
  }

   HPTuneConfig copyWith({
    String? sampling,
    int? cvFoldsNum,
    Map<String, dynamic>? parameters,
    Map<String, String>? metricScore,
  }) {
    return HPTuneConfig(
      sampling: sampling ?? this.sampling,
      cvFoldsNum: cvFoldsNum ?? this.cvFoldsNum,
      parameters: parameters ?? this.parameters,
      metricScore: metricScore ?? this.metricScore,
    );
  }
}

class ModelInferenceConfig {
  final String prodModelsFolder;
  final Map<String, double> metricGrowthValue;
  final int calculateThreshold;
  final List<double> threshold;
  final String? prodPath;  // Nullable

  ModelInferenceConfig({
    required this.prodModelsFolder,
    required this.metricGrowthValue,
    required this.calculateThreshold,
    required this.threshold,
    this.prodPath,  // Nullable
  });

  factory ModelInferenceConfig.fromJson(Map<String, dynamic> json) {
    return ModelInferenceConfig(
      prodModelsFolder: json['prod_models_folder'] ?? '',
      metricGrowthValue: (json['metric_growth_value'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, (value as num).toDouble()))
          ?? {},  // Default empty map
      calculateThreshold: json['calculate_threshold'] ?? 0,
      threshold: (json['threshold'] as List<dynamic>?)
          ?.map((x) => (x as num).toDouble()).toList()
          ?? [0.8, 0.8],  // Default value
      prodPath: json['prod_path'],  // Может быть null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prod_models_folder': prodModelsFolder,
      'metric_growth_value': metricGrowthValue,
      'calculate_threshold': calculateThreshold,
      'threshold': threshold,
      'prod_path': prodPath,
    };
  }

 ModelInferenceConfig copyWith({
    String? prodModelsFolder,
    Map<String, double>? metricGrowthValue,
    int? calculateThreshold,
    List<double>? threshold,
    String? prodPath,
  }) {
    return ModelInferenceConfig(
      prodModelsFolder: prodModelsFolder ?? this.prodModelsFolder,
      metricGrowthValue: metricGrowthValue ?? this.metricGrowthValue,
      calculateThreshold: calculateThreshold ?? this.calculateThreshold,
      threshold: threshold ?? this.threshold,
      prodPath: prodPath ?? this.prodPath,
    );
  } 
}


class AllModelsConfig {
  final String project;
  final String version;
  final String groupName;
  final DataModelConfig dataConfig;
  final List<ModelConfig> modelsConfigs;

  AllModelsConfig({
    required this.project,
    required this.version,
    required this.groupName,
    required this.dataConfig,
    required this.modelsConfigs,
  });

  factory AllModelsConfig.fromJson(Map<String, dynamic> json) {
    return AllModelsConfig(
      project: json['project'],
      version: json['version'],
      groupName: json['group_name'],
      dataConfig: DataModelConfig.fromJson(json['data_config']),
      modelsConfigs: (json['models_configs'] as List)
          .map((e) => ModelConfig.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'version': version,
      'group_name': groupName,
      'data_config': dataConfig.toJson(),
      'models_configs': modelsConfigs.map((e) => e.toJson()).toList(),
    };
  }

  AllModelsConfig copyWith({
    String? project,
    String? version,
    String? groupName,
    DataModelConfig? dataConfig,
    List<ModelConfig>? modelsConfigs,
  }) {
    return AllModelsConfig(
      project: project ?? this.project,
      version: version ?? this.version,
      groupName: groupName ?? this.groupName,
      dataConfig: dataConfig ?? this.dataConfig,
      modelsConfigs: modelsConfigs ?? this.modelsConfigs,
    );
  }
}

class ModelConfig {
  final String name;
  final String? objective;
  final String? wrapper;
  final String? columnTarget;
  final String? columnExposure;
  final List<RelativeFeatureModelConfig> relativeFeatures;
  final List<FeatureModelConfig> features;
  final Map<String, dynamic>? paramsCatboost;
  final Map<String, dynamic>? paramsXgb;
  final Map<String, dynamic>? paramsGlm;
  final Map<String, dynamic>? params;
  final Map<String, String>? treatmentDict;
  final List<String>? catFeaturesCatboost;
  final String? dataFilterCondition;

  ModelConfig({
    required this.name,
    this.objective,
    this.wrapper,
    this.columnTarget,
    this.columnExposure,
    this.relativeFeatures = const [],
    required this.features,
    this.paramsCatboost,
    this.paramsXgb,
    this.paramsGlm,
    this.params,
    this.treatmentDict,
    this.catFeaturesCatboost,
    this.dataFilterCondition,
  });

  factory ModelConfig.fromJson(Map<String, dynamic> json) {
    return ModelConfig(
      name: json['name'],
      objective: json['objective'],
      wrapper: json['wrapper'],
      columnTarget: json['column_target'],
      columnExposure: json['column_exposure'],
      relativeFeatures: (json['relative_features'] as List? ?? [])
          .map((e) => RelativeFeatureModelConfig.fromJson(e))
          .toList(),
      features: (json['features'] as List)
          .map((e) => FeatureModelConfig.fromJson(e))
          .toList(),
      paramsCatboost: json['params_catboost'] != null
          ? Map<String, dynamic>.from(json['params_catboost'])
          : null,
      paramsXgb: json['params_xgb'] != null
          ? Map<String, dynamic>.from(json['params_xgb'])
          : null,
      paramsGlm: json['params_glm'] != null
          ? Map<String, dynamic>.from(json['params_glm'])
          : null,
      params: json['params'] != null
          ? Map<String, dynamic>.from(json['params'])
          : null,
      treatmentDict: json['treatment_dict'] != null
          ? Map<String, String>.from(json['treatment_dict'])
          : null,
      catFeaturesCatboost: json['cat_features_catboost'] != null
          ? List<String>.from(json['cat_features_catboost'])
          : null,
      dataFilterCondition: json['data_filter_condition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'objective': objective,
      'wrapper': wrapper,
      'column_target': columnTarget,
      'column_exposure': columnExposure,
      'relative_features': relativeFeatures.map((e) => e.toJson()).toList(),
      'features': features.map((e) => e.toJson()).toList(),
      'params_catboost': paramsCatboost,
      'params_xgb': paramsXgb,
      'params_glm': paramsGlm,
      'params': params,
      'treatment_dict': treatmentDict,
      'cat_features_catboost': catFeaturesCatboost,
      'data_filter_condition': dataFilterCondition,
    };
  }

  ModelConfig copyWith({
    String? name,
    String? objective,
    String? wrapper,
    String? columnTarget,
    String? columnExposure,
    List<RelativeFeatureModelConfig>? relativeFeatures,
    List<FeatureModelConfig>? features,
    Map<String, dynamic>? paramsCatboost,
    Map<String, dynamic>? paramsXgb,
    Map<String, dynamic>? paramsGlm,
    Map<String, dynamic>? params,
    Map<String, String>? treatmentDict,
    List<String>? catFeaturesCatboost,
    String? dataFilterCondition,
  }) {
    return ModelConfig(
      name: name ?? this.name,
      objective: objective ?? this.objective,
      wrapper: wrapper ?? this.wrapper,
      columnTarget: columnTarget ?? this.columnTarget,
      columnExposure: columnExposure ?? this.columnExposure,
      relativeFeatures: relativeFeatures ?? this.relativeFeatures,
      features: features ?? this.features,
      paramsCatboost: paramsCatboost ?? this.paramsCatboost,
      paramsXgb: paramsXgb ?? this.paramsXgb,
      paramsGlm: paramsGlm ?? this.paramsGlm,
      params: params ?? this.params,
      treatmentDict: treatmentDict ?? this.treatmentDict,
      catFeaturesCatboost: catFeaturesCatboost ?? this.catFeaturesCatboost,
      dataFilterCondition: dataFilterCondition ?? this.dataFilterCondition,
    );
  }
}

class SeparationModelConfig {
  final String kind;
  final int? randomState;
  final double? testTrainProportion;
  final List<dynamic>? trainPeriod;
  final List<dynamic>? testPeriod;
  final List<String>? periodColumn;

  SeparationModelConfig({
    required this.kind,
    this.randomState,
    this.testTrainProportion,
    this.trainPeriod,
    this.testPeriod,
    this.periodColumn,
  });

  factory SeparationModelConfig.fromJson(Map<String, dynamic> json) {
    return SeparationModelConfig(
      kind: json['kind'],
      randomState: json['random_state'],
      testTrainProportion: json['test_train_proportion']?.toDouble(),
      trainPeriod: json['train_period'],
      testPeriod: json['test_period'],
      periodColumn: json['period_column'] != null
          ? List<String>.from(json['period_column'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'random_state': randomState,
      'test_train_proportion': testTrainProportion,
      'train_period': trainPeriod,
      'test_period': testPeriod,
      'period_column': periodColumn,
    };
  }

  SeparationModelConfig copyWith({
    String? kind,
    int? randomState,
    double? testTrainProportion,
    List<dynamic>? trainPeriod,
    List<dynamic>? testPeriod,
    List<String>? periodColumn,
  }) {
    return SeparationModelConfig(
      kind: kind ?? this.kind,
      randomState: randomState ?? this.randomState,
      testTrainProportion: testTrainProportion ?? this.testTrainProportion,
      trainPeriod: trainPeriod ?? this.trainPeriod,
      testPeriod: testPeriod ?? this.testPeriod,
      periodColumn: periodColumn ?? this.periodColumn,
    );
  }
}

class DataConfig {
  final List<dynamic> targetSlices;
  final List<String>? queries;

  DataConfig({
    this.targetSlices = const [],
    this.queries,
  });

  factory DataConfig.fromJson(Map<String, dynamic> json) {
    return DataConfig(
      targetSlices: json['targetslices'] ?? [],
      queries: json['queries'] != null
          ? List<String>.from(json['queries'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetslices': targetSlices,
      'queries': queries,
    };
  }

  DataConfig copyWith({
    List<dynamic>? targetSlices,
    List<String>? queries,
  }) {
    return DataConfig(
      targetSlices: targetSlices ?? this.targetSlices,
      queries: queries ?? this.queries,
    );
  }
}

class DataModelConfig {
  final String? project;
  final String? version;
  final bool? processing;
  final bool? showGraphs;
  final String? source;
  final String? tableNameSource;
  final String? localNameSource;
  final String? extraConditions;
  final Map<String, dynamic>? extraParams;
  final SeparationModelConfig? separation;
  final List<String>? extraColumns;
  final List<dynamic> targetSlices;
  final DataConfig? data;

  DataModelConfig({
    this.project,
    this.version,
    this.processing,
    this.showGraphs,
    this.source,
    this.tableNameSource,
    this.localNameSource,
    this.extraConditions,
    this.extraParams,
    this.separation,
    this.extraColumns,
    this.targetSlices = const [],
    this.data,
  });

  factory DataModelConfig.fromJson(Map<String, dynamic> json) {
    return DataModelConfig(
      project: json['project'],
      version: json['version'],
      processing: json['processing'],
      showGraphs: json['showGraphs'],
      source: json['source'],
      tableNameSource: json['table_name_source'],
      localNameSource: json['local_name_source'],
      extraConditions: json['extra_conditions'],
      extraParams: json['extra_params'] != null
          ? Map<String, dynamic>.from(json['extra_params'])
          : null,
      separation: json['separation'] != null
          ? SeparationModelConfig.fromJson(json['separation'])
          : null,
      extraColumns: json['extra_columns'] != null
          ? List<String>.from(json['extra_columns'])
          : null,
      targetSlices: json['targetslices'] ?? [],
      data: json['data'] != null
          ? DataConfig.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project': project,
      'version': version,
      'processing': processing,
      'showGraphs': showGraphs,
      'source': source,
      'table_name_source': tableNameSource,
      'local_name_source': localNameSource,
      'extra_conditions': extraConditions,
      'extra_params': extraParams,
      'separation': separation?.toJson(),
      'extra_columns': extraColumns,
      'targetslices': targetSlices,
      'data': data?.toJson(),
    };
  }

  DataModelConfig copyWith({
    String? project,
    String? version,
    bool? processing,
    bool? showGraphs,
    String? source,
    String? tableNameSource,
    String? localNameSource,
    String? extraConditions,
    Map<String, dynamic>? extraParams,
    SeparationModelConfig? separation,
    List<String>? extraColumns,
    List<dynamic>? targetSlices,
    DataConfig? data,
  }) {
    return DataModelConfig(
      project: project ?? this.project,
      version: version ?? this.version,
      processing: processing ?? this.processing,
      showGraphs: showGraphs ?? this.showGraphs,
      source: source ?? this.source,
      tableNameSource: tableNameSource ?? this.tableNameSource,
      localNameSource: localNameSource ?? this.localNameSource,
      extraConditions: extraConditions ?? this.extraConditions,
      extraParams: extraParams ?? this.extraParams,
      separation: separation ?? this.separation,
      extraColumns: extraColumns ?? this.extraColumns,
      targetSlices: targetSlices ?? this.targetSlices,
      data: data ?? this.data,
    );
  }
}

class RelativeFeatureModelConfig {
  final String name;
  final String numerator;
  final String denominator;
  final dynamic defaultValue;

  RelativeFeatureModelConfig({
    required this.name,
    required this.numerator,
    required this.denominator,
    required this.defaultValue,
  });

  factory RelativeFeatureModelConfig.fromJson(Map<String, dynamic> json) {
    return RelativeFeatureModelConfig(
      name: json['name'],
      numerator: json['numerator'],
      denominator: json['denominator'],
      defaultValue: json['default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'numerator': numerator,
      'denominator': denominator,
      'default': defaultValue,
    };
  }

  RelativeFeatureModelConfig copyWith({
    String? name,
    String? numerator,
    String? denominator,
    dynamic defaultValue,
  }) {
    return RelativeFeatureModelConfig(
      name: name ?? this.name,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }
}

class FeatureModelConfig {
  final String name;
  final dynamic defaultValue;
  final Map<String, dynamic> replace;
  final Map<String, dynamic>? clip;
  final String? cutNumber;
  final dynamic fillna;
  final String? encoding;
  final Map<String, dynamic>? optbinningParams;
  final List<dynamic>? bins;
  final Map<String, dynamic>? mapping;

  FeatureModelConfig({
    required this.name,
    required this.defaultValue,
    required this.replace,
    this.clip,
    this.cutNumber,
    this.fillna,
    this.encoding,
    this.optbinningParams,
    this.bins,
    this.mapping,
  });

  factory FeatureModelConfig.fromJson(Map<String, dynamic> json) {
    return FeatureModelConfig(
      name: json['name'],
      defaultValue: json['default'],
      replace: Map<String, dynamic>.from(json['replace']),
      clip: json['clip'] != null
          ? Map<String, dynamic>.from(json['clip'])
          : null,
      cutNumber: json['cut_number'],
      fillna: json['fillna'],
      encoding: json['encoding'],
      optbinningParams: json['optbinning_params'] != null
          ? Map<String, dynamic>.from(json['optbinning_params'])
          : null,
      bins: json['bins'],
      mapping: json['mapping'] != null
          ? Map<String, dynamic>.from(json['mapping'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'default': defaultValue,
      'replace': replace,
      'clip': clip,
      'cut_number': cutNumber,
      'fillna': fillna,
      'encoding': encoding,
      'optbinning_params': optbinningParams,
      'bins': bins,
      'mapping': mapping,
    };
  }

  FeatureModelConfig copyWith({
    String? name,
    dynamic defaultValue,
    Map<String, dynamic>? replace,
    Map<String, dynamic>? clip,
    String? cutNumber,
    dynamic fillna,
    String? encoding,
    Map<String, dynamic>? optbinningParams,
    List<dynamic>? bins,
    Map<String, dynamic>? mapping,
  }) {
    return FeatureModelConfig(
      name: name ?? this.name,
      defaultValue: defaultValue ?? this.defaultValue,
      replace: replace ?? this.replace,
      clip: clip ?? this.clip,
      cutNumber: cutNumber ?? this.cutNumber,
      fillna: fillna ?? this.fillna,
      encoding: encoding ?? this.encoding,
      optbinningParams: optbinningParams ?? this.optbinningParams,
      bins: bins ?? this.bins,
      mapping: mapping ?? this.mapping,
    );
  }
}

