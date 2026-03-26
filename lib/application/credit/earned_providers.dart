import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';
import 'package:tanni_simulator/domain/service/credit_limit_service.dart';

part 'earned_providers.g.dart';

@riverpod
int getEarnedLimitedCredits(
  Ref ref,
) {
  final profCredits = ref.watch(
    getEarnedCategoryLimitedCreditsProvider(
      CategoryType.professional,
    ),
  );
  final genCredits = ref.watch(
    getEarnedCategoryLimitedCreditsProvider(CategoryType.general),
  );

  return profCredits + genCredits;
}

@riverpod
int getEarnedCategoryLimitedCredits(
  Ref ref,
  CategoryType categoryType,
) {
  final clService = ref.watch(creditLimitServiceProvider);
  final ccService = ref.watch(creditCalculatorServiceProvider);
  final allCourses = ref.watch(courseListProvider);

  final curriculumAsync = ref.watch(loadingCurriculumUsecaseProvider);
  return curriculumAsync.maybeWhen(
    data: (curriculum) {
      if(curriculum == null) return 0;

      final cl = curriculum.creditLimitGroups.firstWhereOrNull(
        (cl) => cl.category == categoryType,
      );

      if (cl == null) {
        return ccService.getEarnedCategoryCredits(allCourses, categoryType);
      }

      final applyLimitedRuleCredits = clService.calculateEffectiveCredits(
        allCourses: allCourses,
        limitGroup: cl,
        calculator: ccService,
      );

      return applyLimitedRuleCredits;
    }, 
    orElse: () => 0
  );
}
