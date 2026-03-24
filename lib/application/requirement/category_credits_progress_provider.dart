import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/core/utils/switch_by_categories_length.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';
import 'package:tanni_simulator/domain/service/requirement_credit_judge_service.dart';

part 'category_credits_progress_provider.g.dart';

@riverpod
bool isProfessionalRequirementMet(Ref ref) {
  final selectedRequirement = ref.watch(selectedRequirementProvider);
  if (selectedRequirement == null) return true;

  final ccService = ref.watch(creditCalculatorServiceProvider);
  final rcjService = ref.watch(requirementCreditJudgeServiceProvider);
  final courses = ref.watch(courseListProvider);
  final profCredits = ccService.getEarnedCategoryCredits(courses, CategoryType.professional);

  return rcjService.isProfessionalRequirementMet(ref, selectedRequirement, profCredits);
}

@riverpod
bool isGeneralRequirementMet(Ref ref) {
  final selectedRequirement = ref.watch(selectedRequirementProvider);
  if (selectedRequirement == null) return true;

  final ccService = ref.watch(creditCalculatorServiceProvider);
  final rcjService = ref.watch(requirementCreditJudgeServiceProvider);
  final courses = ref.watch(courseListProvider);
  final genCredits = ccService.getEarnedCategoryCredits(courses, CategoryType.general);

  return rcjService.isGeneralRequirementMet(ref, selectedRequirement, genCredits);
}

@riverpod
(int total, int target)? categoryCreditsEarned(Ref ref, CategoryType categoryType) {
  final selectedRequirement = ref.watch(selectedRequirementProvider);
  if (selectedRequirement == null) return null;

  final ccService = ref.watch(creditCalculatorServiceProvider);
  final courses = ref.watch(courseListProvider);
  
  final total = ccService.getEarnedCategoryCredits(courses, categoryType);

  return switchByCategoriesLength<(int, int)?>(
    selectedRequirement,
    () => null,
    (category, type) {
      if (type != categoryType) return null;
      return (total, category.minCredits);
    },
    (prof, gen) {
      return switch (categoryType) {
        CategoryType.professional => (total, prof.minCredits),
        CategoryType.general => (total, gen.minCredits),
      };
    },
  );
}
