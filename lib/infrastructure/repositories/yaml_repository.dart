import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/core/utils/yaml_to_map.dart';
import 'package:tanni_simulator/domain/repositories/i_yaml_repository.dart';
import 'package:tanni_simulator/infrastructure/models/curriculum.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

part 'yaml_repository.g.dart';

@riverpod
IYamlRepository yamlRepository(Ref ref) {
  return YamlRepositoryImpl();
}

class YamlRepositoryImpl extends IYamlRepository {
  @override
  Future<CurriculumModel> loadFromAssets(String path) async {
    final rawYaml = await rootBundle.loadString(path);
    final yamlMap = loadYaml(rawYaml) as YamlMap;
    
    final map = yamlToMap(yamlMap);
    
    return CurriculumModel.fromJson(map);
  }
}
