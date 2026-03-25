import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/widgets/app_chip.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';
import 'package:tanni_simulator/presentation/widgets/app_progress_bar.dart';

class CheckCategoryRequirement extends HookConsumerWidget {
  const CheckCategoryRequirement({
    required this.icon,
    required this.total,
    required this.target,
    required this.chip,
    super.key,
  });

  final Icon icon;
  final int total;
  final int target;
  final AppChip chip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        icon,
        const AppGap.xs(),
        SizedBox(
          width: 100,
          child: Text(
            l10n.tanni_count(total, target),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const AppGap.s(),
        Expanded(
          flex: 3,
          child: AppProgressBar(
            total: total,
            target: target,
          ),
        ),
        const AppGap.s(),
        Expanded(
          child: chip,
        ),
      ],
    );
  }
}
