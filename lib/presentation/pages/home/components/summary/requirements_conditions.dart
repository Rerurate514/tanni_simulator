import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/core/utils/join_category_course.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';
import 'package:tanni_simulator/domain/service/credit_requirements_condiction_service.dart';

class RequirementsConditions extends HookConsumerWidget {
  const RequirementsConditions({super.key, required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ccService = ref.watch(creditCalculatorServiceProvider);
    final crcService = ref.watch(creditRequirementsCondictionServiceProvider);

    final selectedRequirement = ref.watch(selectedRequirementProvider);
    if(selectedRequirement == null) return SizedBox.shrink();

    final courses = ref.watch(courseListProvider);
    final earned = ccService.getEarnedCredits(courses);

    //最低単位数を満たしているかどうか
    final isRequirementMet = crcService.isRequirementMet(
      selectedRequirement,
      ccService.calculateTotal(courses)
    );

    //カテゴリごとの最低単位数を満たしているかどうか
    final checkRequirementStatus = crcService.checkRequirementStatus(
      selectedRequirement,
      ccService.getEarnedCategoryCredits(courses, CategoryType.professional),
      ccService.getEarnedCategoryCredits(courses, CategoryType.general)
    );

    //進級に必要な必修科目を履修しているかどうか
    final getMissingCourses = crcService.getMissingCourses(
      selectedRequirement,
      earned,
      joinCategoryAllCourse(curriculum)
    );

    return Column(
      children: [
        Text(isRequirementMet.toString()),
        Text(checkRequirementStatus.toString()),
        Text(getMissingCourses.toString())
      ],
    );
  }
}
