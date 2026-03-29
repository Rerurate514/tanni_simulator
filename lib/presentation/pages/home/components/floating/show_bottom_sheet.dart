import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/requirement/missing_courses_list_provider.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/core/utils/app_color_scheme.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/bottom/missing_courses_bottom_sheet.dart';

class ShowBottomSheetButton extends HookConsumerWidget {
  const ShowBottomSheetButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final table = ref.watch(loadingCurriculumUsecaseProvider);
    final selectedRequirement = ref.watch(selectedRequirementProvider);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 4,
      child: table.when(
        error: (e, stack) => Text('${l10n.msg_error_load_failed}\n$e: $stack'),
        loading: CircularProgressIndicator.new,
        data: (curriculum) {
          if (curriculum == null) return const CircularProgressIndicator();
          if (selectedRequirement == null) {
            return _buildNoneRequirementCredits();
          }

          final missingCourses = ref.watch(
            missingCoursesListProvider(selectedRequirement, curriculum),
          );
          
          return IconButton(
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => MissingCoursesBottomSheet(
                  curriculum: curriculum,
                  selectedRequirement: selectedRequirement,
                ),
              );
            },
            icon: Icon(
              missingCourses.isEmpty
              ? Icons.check_circle
              : Icons.warning_amber_rounded,
              size: 32,
              color: missingCourses.isEmpty
              ? theme.colorScheme.success
              : theme.colorScheme.error,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoneRequirementCredits() {
    return const Padding(
      padding: EdgeInsetsGeometry.all(6),
      child: Icon(
        Icons.info_outline,
        size: 32,
        color: Colors.grey,
      ),
    );
  }
}
