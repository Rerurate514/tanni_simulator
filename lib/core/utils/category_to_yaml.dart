import 'package:tanni_simulator/domain/constants/category_type.dart';

Map<String, dynamic> addPropertyToYaml(Map<String, dynamic> originalYaml) {
  final yaml1 = _addCourseCategoryToYaml(originalYaml);
  final yaml2 = _addRequirementsCategoryToYaml(yaml1);

  return yaml2;
}

Map<String, dynamic> _addCourseCategoryToYaml(Map<String, dynamic> originalYaml) {
  final yaml = Map<String, dynamic>.from(originalYaml);

  for (final course in yaml['university_curriculum'][CategoryType.professional.index]['courses']) {
    course['category'] = CategoryType.professional.name;
  }
  
  for (final course in yaml['university_curriculum'][CategoryType.general.index]['courses']) {
    course['category'] = CategoryType.general.name;
  }

  return yaml;
}

Map<String, dynamic> _addRequirementsCategoryToYaml(Map<String, dynamic> originalYaml) {
  final yaml = Map<String, dynamic>.from(originalYaml);

  for (final requirement in yaml['requirements']) {
    for (final category in requirement['categories']) {
      if(category['category_name'] == CategoryType.professional.nameJP) {
        category['category'] = CategoryType.professional.name;
      } else if(category['category_name'] == CategoryType.general.nameJP){
        category['category'] = CategoryType.general.name;
      } else {
        throw Exception('requirementsのcategoriesのcategory_nameが既存定義と合致しません。');
      }
    }
  }

  return yaml;
}
