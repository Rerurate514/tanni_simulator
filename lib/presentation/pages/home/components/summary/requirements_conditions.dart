import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/check_requirement_status.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/is_requirement_met.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/missing_courses.dart';
import 'package:tanni_simulator/application/requirement/requirement_conditions_providers.dart';
import 'package:tanni_simulator/application/requirement/missing_courses_list_provider.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class RequirementsConditions extends HookConsumerWidget {
  const RequirementsConditions({super.key, required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequirement = ref.watch(selectedRequirementProvider);
    if(selectedRequirement == null) return SizedBox.shrink();

    final isRequirementMet = ref.watch(isRequirementMetProvider(selectedRequirement));
    final requirementStatus = ref.watch(requirementStatusProvider(selectedRequirement));
    final missingCourses = ref.watch(missingCoursesListProvider(
      selectedRequirement,
      curriculum
    ));

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            IsRequirementMet(
              isRequirementMet: isRequirementMet
            ),
            if(isRequirementMet) AppGap.s(),
            CheckRequirementStatus(
              requirementStatus: requirementStatus
            ),
            if(requirementStatus != RequirementStatus.notExist) AppGap.s(),
            MissingCourses(
              missingCourses: missingCourses
            )
          ],
        ),
      )
    );
  }
}
