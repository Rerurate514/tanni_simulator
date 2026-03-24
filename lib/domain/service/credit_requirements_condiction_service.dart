import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';

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
    final prof = requirement.categories[CategoryType.professional.index];
    final gen = requirement.categories[CategoryType.general.index];

    if (profCredits < prof.minCredits) {
      return RequirementStatus.professionalCreditShortage;
    }
    if (genCredits < gen.minCredits) {
      return RequirementStatus.generalCreditShortage;
    }

    return RequirementStatus.fulfilled;
  }

  // categoriesのcategoryのmust_have_course_idsに書いてある単位を履修しているか
  // 帰り値は履修していない授業IDsが返される。
  List<CourseModel> getMissingCourses(
    RequirementModel requirement,
    List<CourseModel> earnedCourses,
    List<CourseModel> allCourses,
  ) {
    final profIds = requirement.categories[CategoryType.professional.index].mustHaveCourseIds;
    final genIds = requirement.categories[CategoryType.general.index].mustHaveCourseIds;
    
    final allMustIds = [...profIds, ...genIds];
    final earnedIds = earnedCourses.map((c) => c.id).toSet();

    final missingIds = allMustIds.where((id) => !earnedIds.contains(id)).toSet();

    return allCourses.where((course) => missingIds.contains(course.id)).toList();
  }
}
