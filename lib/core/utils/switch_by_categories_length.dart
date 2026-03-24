  import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';
import 'package:tanni_simulator/domain/entities/requirement_category.dart';

T switchByCategoriesLength<T>(
    RequirementModel requirement,
    T Function() onNoCategory,
    T Function(RequirementCategoryModel category, CategoryType categoryType) onOneCategory,
    T Function(RequirementCategoryModel prof, RequirementCategoryModel gen) onTwoCategories,
  ) {
    final categories = requirement.categories;

    return switch (categories.length) {
      0 => onNoCategory(),
      1 => onOneCategory(categories[0], categories[0].category),
      _ => () {
        final prof = categories.firstWhere((c) => c.category == CategoryType.professional);
        final gen = categories.firstWhere((c) => c.category == CategoryType.general);
        return onTwoCategories(prof, gen);
      }(),
    };
  }
