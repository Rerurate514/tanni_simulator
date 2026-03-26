import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/repositories/i_yaml_repository.dart';
import 'package:yaml/yaml.dart';

part 'yaml_repository.g.dart';

@riverpod
IYamlRepository yamlRepository(Ref ref) {
  return YamlRepositoryImpl();
}

class YamlRepositoryImpl extends IYamlRepository {
  @override
  Future<Map<String, dynamic>> loadFromAssets(String path) async {
    final rawYaml = await rootBundle.loadString(path);
    final yamlMap = loadYaml(rawYaml) as YamlMap;

    final map = _yamlToMap(yamlMap);
    final injectedMap = _addPropertyToYaml(map);

    return injectedMap;
  }

  Map<String, dynamic> _yamlToMap(YamlMap yamlMap) {
    final map = <String, dynamic>{};

    for (final entry in yamlMap.entries) {
      final key = entry.key.toString();
      final value = entry.value;

      if (value is YamlMap) {
        map[key] = _yamlToMap(value);
      } else if (value is YamlList) {
        map[key] = value.map((e) => e is YamlMap ? _yamlToMap(e) : e).toList();
      } else {
        map[key] = value;
      }
    }
    return map;
  }

  Map<String, dynamic> _addPropertyToYaml(Map<String, dynamic> originalYaml) {
    final yaml1 = _addCourseCategoryToYaml(originalYaml);
    final yaml2 = _addRequirementsCategoryToYaml(yaml1);
    final yaml3 = _addCreditLimitRuleCategoryToYaml(yaml2);

    return yaml3;
  }

  Map<String, dynamic> _addCourseCategoryToYaml(
    Map<String, dynamic> originalYaml,
  ) {
    final yaml = Map<String, dynamic>.from(originalYaml);
    final curriculum = yaml['university_curriculum'] as List<dynamic>;

    final profSection =
        curriculum[CategoryType.professional.index] as Map<String, dynamic>;

    final profCourses = profSection['courses'] as List<dynamic>;
    for (final course in profCourses) {
      (course as Map<String, dynamic>)['category'] =
          CategoryType.professional.name;
    }

    final genSection =
        curriculum[CategoryType.general.index] as Map<String, dynamic>;
    final genCourses = genSection['courses'] as List<dynamic>;
    for (final course in genCourses) {
      (course as Map<String, dynamic>)['category'] = CategoryType.general.name;
    }

    return yaml;
  }

  Map<String, dynamic> _addRequirementsCategoryToYaml(
    Map<String, dynamic> originalYaml,
  ) {
    final yaml = Map<String, dynamic>.from(originalYaml);

    final requirements = yaml['requirements'] as List<dynamic>;

    for (final requirement in requirements) {
      final reqMap = requirement as Map<String, dynamic>;
      final categories = reqMap['categories'] as List<dynamic>;

      for (final category in categories) {
        final catMap = category as Map<String, dynamic>;
        final categoryName = catMap['category_name'] as String;

        if (categoryName == CategoryType.professional.nameJP) {
          catMap['category'] = CategoryType.professional.name;
        } else if (categoryName == CategoryType.general.nameJP) {
          catMap['category'] = CategoryType.general.name;
        } else {
          throw Exception(
            'requirementsのcategoriesのcategory_nameが既存定義と合致しません。: $categoryName',
          );
        }
      }
    }

    return yaml;
  }

  Map<String, dynamic> _addCreditLimitRuleCategoryToYaml(
    Map<String, dynamic> originalYaml,
  ) {
    final yaml = Map<String, dynamic>.from(originalYaml);

    final creditLimitRule = yaml['credit_limit_rules'] as List<dynamic>;

    for (final cl in creditLimitRule) {
      final clMap = cl as Map<String, dynamic>;

      final categoryName = clMap['category_name'] as String;

      if (categoryName == CategoryType.professional.nameJP) {
        clMap['category'] = CategoryType.professional.name;
      } else if (categoryName == CategoryType.general.nameJP) {
        clMap['category'] = CategoryType.general.name;
      } else {
        throw Exception(
          'credit_limit_rulesのcategory_nameが既存定義と合致しません。: $categoryName',
        );
      }
    }

    return yaml;
  }
}
