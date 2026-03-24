import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';
import 'package:tanni_simulator/domain/entities/requirement_category.dart';

part 'credit_requirements_condiction_service.g.dart';

@riverpod
CreditRequirementsCondictionService creditRequirementsCondictionService(Ref ref) {
  return const CreditRequirementsCondictionService();
}

class CreditRequirementsCondictionService {
  const CreditRequirementsCondictionService();

  // total_credits_requiredを超えているかどうか
  bool isRequirementMet(RequirementModel requirement, int totalCredits) {
    if(requirement.totalCreditsRequired == null) return false;

    return requirement.totalCreditsRequired! >= totalCredits;
  }

  // categoriesの専門教養それぞれのmin_creditsを超えているか
  RequirementStatus checkRequirementStatus(
    RequirementModel requirement,
    int profCredits,
    int genCredits,
  ) {
    return _switchByCategoriesLength<RequirementStatus>(
      requirement, 
      () {
        return RequirementStatus.fulfilled;
      }, 
      (category, categoryType) {
        switch(categoryType){
          case CategoryType.professional: {
            final isExceedProfCredits = profCredits < category.minCredits;
            if(!isExceedProfCredits) return RequirementStatus.professionalCreditShortage;
          }
          case CategoryType.general: {
            final isExceedGenCredits = genCredits < category.minCredits;
            if(!isExceedGenCredits) return RequirementStatus.generalCreditShortage;
          }
        }

        return RequirementStatus.fulfilled;
      }, 
      () {
        final prof = requirement.categories[CategoryType.professional.index];
        final gen = requirement.categories[CategoryType.general.index];

        final isExceedProfCredits = profCredits < prof.minCredits;
        final isExceedGenCredits = genCredits < gen.minCredits;

        if(isExceedProfCredits && isExceedGenCredits) {
          return RequirementStatus.bothCreditShortage;
        }
        if (isExceedProfCredits) {
          return RequirementStatus.professionalCreditShortage;
        }
        if (isExceedGenCredits) {
          return RequirementStatus.generalCreditShortage;
        }

        return RequirementStatus.fulfilled;
      }
    );
  }

  // categoriesのcategoryのmust_have_course_idsに書いてある単位を履修しているか
  // 帰り値は履修していない授業IDsが返される。
  List<CourseModel> getMissingCourses(
    RequirementModel requirement,
    List<CourseModel> earnedCourses,
    List<CourseModel> allCourses,
  ) {
    final earnedIds = earnedCourses.map((c) => c.id).toSet();
    return _switchByCategoriesLength<List<CourseModel>>(
      requirement, 
      () {
        return [];
      }, 
      (category, categoryType) {
        final ids = category.mustHaveCourseIds;
        final missingIds = ids.where((id) => !earnedIds.contains(id)).toSet();

        return allCourses.where((course) => missingIds.contains(course.id)).toList();
      }, 
      () {
        final profIds = requirement.categories[CategoryType.professional.index].mustHaveCourseIds;
        final genIds = requirement.categories[CategoryType.general.index].mustHaveCourseIds;
        
        final allMustIds = [...profIds, ...genIds];
        final missingIds = allMustIds.where((id) => !earnedIds.contains(id)).toSet();

        return allCourses.where((course) => missingIds.contains(course.id)).toList();
      }
    );
    
  }

  T _switchByCategoriesLength<T>(
    RequirementModel requirement,
    T Function() onNoCategory,
    T Function(RequirementCategoryModel, CategoryType) onOneCategory,
    T Function() onTwoCategory,
  ) {
    final categories = requirement.categories;

    return switch (categories.length) {
      0 => onNoCategory(),
      1 => onOneCategory(categories[0], categories[0].category),
      _ => onTwoCategory(),
    };
  }
}
