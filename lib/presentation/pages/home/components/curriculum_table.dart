import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/curriculum_summary.dart';
import 'package:tanni_simulator/presentation/pages/home/components/curriculum_table_categories.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumTable extends StatefulHookConsumerWidget {
  const CurriculumTable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurriculumTableState();
}
class _CurriculumTableState extends ConsumerState<CurriculumTable> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final table = ref.watch(loadingCurriculumUsecaseProvider);

    return table.when(
      error: (e, stack) => Text("${l10n.msg_error_load_failed}\n$e: $stack"), 
      loading: () => CircularProgressIndicator(),
      data: (CurriculumModel? model) {
        if(model == null) return Text(l10n.msg_select_curriculum_first);
        return Column(
          children: [
            CurriculumSummary(curriculum: model),
            AppGap.s(),
            Expanded(child: CurriculumTableCategories(categories: model.universityCurriculum))
          ],
        );
      }, 
    );
  }
}
