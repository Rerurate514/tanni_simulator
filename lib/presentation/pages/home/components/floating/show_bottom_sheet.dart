import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/bottom/missing_courses_bottom_sheet.dart';

class ShowBottomSheetButton extends HookConsumerWidget {
  const ShowBottomSheetButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final table = ref.watch(loadingCurriculumUsecaseProvider);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 4,
      child: table.when(
        error: (e, stack) => Text('${l10n.msg_error_load_failed}\n$e: $stack'),
        loading: CircularProgressIndicator.new,
        data: (curriculum) {
          if(curriculum == null) return const CircularProgressIndicator();
          return IconButton(
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => MissingCoursesBottomSheet(
                  curriculum: curriculum,
                ),
              );
            }, 
            icon: const Icon(
              Icons.check_circle,
              size: 32,
            )
          );
        },
      )
    );
  }
}
