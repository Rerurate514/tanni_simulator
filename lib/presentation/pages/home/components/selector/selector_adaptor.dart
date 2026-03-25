import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/presentation/pages/home/components/selector/curriculum_selector.dart';
import 'package:tanni_simulator/presentation/pages/home/components/selector/promotion_gate_selector.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class SelectorAdaptor extends HookConsumerWidget {
  const SelectorAdaptor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = ref.watch(loadingCurriculumUsecaseProvider);

    return Row(
      children: [
        const Expanded(child: CurriculumSelector()),
        const AppGap.s(),
        Expanded(
          child: table.when(
            error: (e, stack) => const Expanded(child: SizedBox.shrink()),
            loading: () => const Expanded(child: SizedBox.shrink()),
            data: (curriculum) {
              if (curriculum == null) {
                return const SizedBox.shrink();
              }
              return PromotionGateSelector(
                requirements: curriculum.requirements,
              );
            },
          ),
        ),
      ],
    );
  }
}
