import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/core/utils/term_ex.dart';
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
    final l10n = AppLocalizations.of(context);
    final prod = widget.categories[0];
    final gen = widget.categories[1];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: Text(l10n.category_elective)),
        ..._buildTermSlivers(context, prod.courses),

        SliverToBoxAdapter(child: const Divider()),
        SliverToBoxAdapter(child: Text(l10n.category_general)),
        ..._buildTermSlivers(context, gen.courses),
      ],
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
