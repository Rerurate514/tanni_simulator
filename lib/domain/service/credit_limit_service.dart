import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/credit_limit_group.dart';
import 'package:tanni_simulator/domain/entities/credit_limited_rule.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';

part 'credit_limit_service.g.dart';

@riverpod
CreditLimitService creditLimitService(Ref ref) {
  return const CreditLimitService();
}

class CreditLimitService {
  const CreditLimitService();

  int calculateEffectiveCredits({
    required List<CourseModel> allCourses,
    required CreditLimitGroupModel limitGroup,
    required CreditCalculatorService calculator,
  }) {
    final categoryCourses = allCourses
        .where((c) => c.category.nameJP == limitGroup.categoryName)
        .toList();

    var effectiveTotal = calculator.calculateTotalCreditsEarned(
      categoryCourses,
    );

    for (final rule in limitGroup.groups) {
      final groupCourses = rule.courseIds.toCourses(allCourses);
      final rawEarnedInGroup = calculator.calculateTotalCreditsEarned(
        groupCourses,
      );

      if (rawEarnedInGroup > rule.maxCreditsAllowed) {
        final excess = rawEarnedInGroup - rule.maxCreditsAllowed;
        effectiveTotal -= excess;
      }
    }

    return effectiveTotal;
  }

  int calculateEffectiveCategoryCredits({
    required List<CourseModel> allCourses,
    required CreditLimitGroupModel limitGroup,
    required CreditCalculatorService calculator,
  }) {
    final categoryCourses = allCourses
        .where((c) => c.category.nameJP == limitGroup.categoryName)
        .toList();

    var effectiveTotal = calculator.calculateTotalCreditsEarned(
      categoryCourses,
    );

    for (final rule in limitGroup.groups) {
      final groupCourses = rule.courseIds.toCourses(allCourses);
      final rawEarnedInGroup = calculator.calculateTotalCreditsEarned(
        groupCourses,
      );

      if (rawEarnedInGroup > rule.maxCreditsAllowed) {
        final excess = rawEarnedInGroup - rule.maxCreditsAllowed;
        effectiveTotal -= excess;
      }
    }

    return effectiveTotal;
  }

  List<CreditLimitRuleModel> findRuleByCourse({
    required List<CreditLimitGroupModel> limitGroups,
    required CourseModel course,
  }) {
    return limitGroups
      .expand((cl) => cl.groups)
      .where((rule) => rule.courseIds.contains(course.id))
      .toList();
  }
}
