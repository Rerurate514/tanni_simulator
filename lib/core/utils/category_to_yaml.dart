import 'package:tanni_simulator/domain/constants/category_type.dart';

Map<String, dynamic> addPropertyToYaml(Map<String, dynamic> originalYaml) {
  final yaml1 = _addCourseCategoryToYaml(originalYaml);
  final yaml2 = _addRequirementsCategoryToYaml(yaml1);

  return yaml2;
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
