import 'package:tanni_simulator/domain/constants/category_type.dart';

Map<String, dynamic> addCourseCategoryToYaml(Map<String, dynamic> originalYaml) {
  final yaml = Map<String, dynamic>.from(originalYaml);

  for (var course in yaml["university_curriculum"][CategoryType.professional.index]["courses"]) {
    course["category"] = CategoryType.professional.name;
  }
  
  for (var course in yaml["university_curriculum"][CategoryType.general.index]["courses"]) {
    course["category"] = CategoryType.general.name;
  }

  return yaml;
}
