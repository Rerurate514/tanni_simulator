import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/presentation/pages/home/components/selector/curriculum_selector.dart';
import 'package:tanni_simulator/presentation/pages/home/components/table/curriculum_table.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';
import 'package:tanni_simulator/presentation/widgets/page_wrapper.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}
class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Column(
        children: [
          CurriculumSelector(),
          AppGap.s(),
          Expanded(child: CurriculumTable()),
        ],
      ),
    );
  }
}
