import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/credit/is_credit_completed_provider.dart';
import 'package:tanni_simulator/application/state/credit_limit_group_notifier.dart';
import 'package:tanni_simulator/application/state/exclusive_groups_notifier.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/service/credit_limit_service.dart';
import 'package:tanni_simulator/domain/service/exclusive_groups_service.dart';
import 'package:tanni_simulator/presentation/pages/home/state/table/course_card_state.dart';

part 'course_card_state_provider.g.dart';

@riverpod
CourseCardState courseCardStateProvider(
  Ref ref, 
  CourseModel course,
  ThemeData theme
) {
    final isCreditsCompleted = ref.watch(
      isCreditCompletedProvider(course),
    );

    final egService = ref.watch(exclusiveGroupServiceProvider);
    final egs = ref.watch(exclusiveGroupsProvider);
    final eg = egService.findGroupByCourse(egs, course);

    final activeColor = isCreditsCompleted
        ? theme.colorScheme.primary
        : theme.dividerColor.withAlpha(40);

    final clService = ref.watch(creditLimitServiceProvider);
    final clgs = ref.watch(creditLimitGroupProvider);
    final clrs = clService.findRuleByCourse(
      limitGroups: clgs,
      course: course
    );

    return CourseCardState(
      isCreditsCompleted: isCreditsCompleted, 
      eg: eg, 
      activeColor: activeColor, 
      clrs: clrs
    );
}
