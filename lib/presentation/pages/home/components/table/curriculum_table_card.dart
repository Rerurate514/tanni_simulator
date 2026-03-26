import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/presentation/pages/home/components/table/table_card_chips.dart';
import 'package:tanni_simulator/presentation/pages/home/providers/course_card_state_provider.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumTableCard extends HookConsumerWidget {
  const CurriculumTableCard({required this.course, super.key});

  final CourseModel course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final cardState = ref.watch(courseCardStateProviderProvider(course, theme));

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 300,
      ),
      child: Card(
        elevation: cardState.isCreditsCompleted ? 0 : 2,
        color: cardState.isCreditsCompleted
            ? theme.colorScheme.primaryContainer.withAlpha(40)
            : theme.cardColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: cardState.activeColor,
            width: cardState.isCreditsCompleted ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => ref.read(courseListProvider.notifier).toggle(course),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      course.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: cardState.isCreditsCompleted
                            ? theme.colorScheme.onSurface
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const AppGap.xs(),

                    TableCardChips(
                      course: course,
                      eg: cardState.eg,
                      clrs: cardState.clrs,
                    ),
                  ],
                ),
              ),
              if (cardState.isCreditsCompleted) _buildCompletedIcon(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedIcon(ThemeData theme) {
    return Positioned(
      top: 4,
      right: 4,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Icon(
            Icons.check_circle,
            size: 18,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
