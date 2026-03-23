import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/core/utils/term_ex.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/category.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/curriculum_table_card.dart';
import 'package:collection/collection.dart';
import 'package:tanni_simulator/presentation/widgets/app_gap.dart';

class CurriculumTableCategories extends StatefulHookConsumerWidget {
  const CurriculumTableCategories({super.key, required this.categories});
  final List<CategoryModel> categories;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurriculumCategoriesState();
}

class _CurriculumCategoriesState extends ConsumerState<CurriculumTableCategories> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final prod = widget.categories[CategoryType.professional.index];
    final gen = widget.categories[CategoryType.general.index];

    return CustomScrollView(
      slivers: [
        _buildProChip(theme, l10n),
        ..._buildTermSlivers(context, prod.courses),

        SliverToBoxAdapter(
          child: AppGap.l(),
        ),

        SliverToBoxAdapter(child: const Divider()),
        _buildGenChip(theme, l10n),
        ..._buildTermSlivers(context, gen.courses),
      ],
    );
  }

  Widget _buildProChip(ThemeData theme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 20,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.category_professional,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenChip(ThemeData theme, AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryFixedDim,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history_edu,
                  size: 20,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.category_general,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTermSlivers(BuildContext context, List<CourseModel> courses) {
    final l10n = AppLocalizations.of(context);
    final coursesByTerm = groupBy(courses, (CourseModel c) => c.term);
    final sortedTerms = coursesByTerm.keys.toList();

    return [
      for (final term in sortedTerms) ...[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                AppGap.xs(),
                Text(
                  term.toTermName(l10n),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                AppGap.xs(),
                Text(
                  l10n.kamoku_count(coursesByTerm[term]!.length),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, i) => CurriculumTableCard(courseModel: coursesByTerm[term]![i]),
            childCount: coursesByTerm[term]!.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisExtent: 80,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
        ),
      ],
    ];
  }
}
