import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/core/utils/join_category_course.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';
import 'package:tanni_simulator/domain/service/requirement_course_analyst_service.dart';
import 'package:tanni_simulator/domain/service/requirement_credit_judge_service.dart';

part 'requirement_conditions_providers.g.dart';

@riverpod
bool isRequirementMet(Ref ref, RequirementModel selectedRequirement) {
  final ccService = ref.watch(creditCalculatorServiceProvider);
  final rcjService = ref.watch(requirementCreditJudgeServiceProvider);

  final courses = ref.watch(courseListProvider);

  return rcjService.isRequirementMet(
    selectedRequirement,
    ccService.calculateTotal(courses)
  );
}

@riverpod
RequirementStatus requirementStatus(Ref ref, RequirementModel selectedRequirement) {
  final ccService = ref.watch(creditCalculatorServiceProvider);
  final rcjService = ref.watch(requirementCreditJudgeServiceProvider);
  final courses = ref.watch(courseListProvider);

  return rcjService.checkRequirementStatus(
    selectedRequirement,
    ccService.getEarnedCategoryCredits(courses, CategoryType.professional),
    ccService.getEarnedCategoryCredits(courses, CategoryType.general)
  );
}

@riverpod
List<CourseModel> mandatoryCourses(Ref ref, RequirementModel selectedRequirement, CurriculumModel curriculum) {
  final ccService = ref.watch(creditCalculatorServiceProvider);
  final rcaService = ref.watch(requirementCourseAnalystServiceProvider);
  final courses = ref.watch(courseListProvider);
  final earned = ccService.getEarnedCredits(courses);
  
  return rcaService.getMissingCourses(
    selectedRequirement,
    earned,
    joinCategoryAllCourse(curriculum)
  );
}

@riverpod
List<CourseModel>? checkAllRequiredSubjectsMet(Ref ref, RequirementModel selectedRequirement, CurriculumModel curriculum) {
  final ccService = ref.watch(creditCalculatorServiceProvider);
  final rcaService = ref.watch(requirementCourseAnalystServiceProvider);
  final courses = ref.watch(courseListProvider);
  final earned = ccService.getEarnedCredits(courses);
  
  return rcaService.checkAllRequiredSubjectsMet(
    selectedRequirement,
    earned,
    joinCategoryAllCourse(curriculum)
  );
}
