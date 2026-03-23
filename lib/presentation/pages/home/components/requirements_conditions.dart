import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
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
    if(selectedRequirement == null) return Text("Container");

    final courses = ref.watch(courseListProvider);
    final earned = ccService.getEarnedCredits(courses);
    final isRequirementMet = crcService.isRequirementMet(
      selectedRequirement,
      ccService.calculateTotal(courses)
    );
    final checkRequirementStatus = crcService.checkRequirementStatus(
      selectedRequirement,
      0,
      0
    );
    final getMissingCourses = crcService.getMissingCourses(
      selectedRequirement,
      [],
      []
    );

    return Column(
      children: [
        
      ],
    );
  }
}
