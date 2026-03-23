import 'package:yaml/yaml.dart';

Map<String, dynamic> yamlToMap(YamlMap yamlMap) {
  final map = <String, dynamic>{};
  
  for (final entry in yamlMap.entries) {
    final key = entry.key.toString();
    final value = entry.value;

    if (value is YamlMap) {
      map[key] = yamlToMap(value);
    } else if (value is YamlList) {
      map[key] = value.map((e) => e is YamlMap ? yamlToMap(e) : e).toList();
    } else {
      map[key] = value;
    }
  }
  return map;
}
