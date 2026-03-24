import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/check_general_requirement.dart';
import 'package:tanni_simulator/presentation/pages/home/components/summary/check_professional_requirement.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CheckRequirementStatus extends HookConsumerWidget {
  const CheckRequirementStatus({super.key, required this.requirementStatus});
  
  final RequirementStatus requirementStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (requirementStatus == RequirementStatus.fulfilled) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CheckProfessionalRequirement(),
        AppGap.s(),
        CheckGeneralRequirement()
      ],
    );
  }
}
