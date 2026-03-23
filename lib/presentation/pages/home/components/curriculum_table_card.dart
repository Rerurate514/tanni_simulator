import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/components/credit_required_chip.dart';

class CurriculumTableCard extends HookConsumerWidget {
  const CurriculumTableCard({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRequired = courseModel.isRequired;

    final isSelected = useState(false);

    return Card(
      elevation: 2,
      color: isSelected.value ? theme.secondaryHeaderColor : theme.cardColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withAlpha(40)),
      ),
      child: InkWell(
        onTap: () {
          isSelected.value = !isSelected.value;
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                courseModel.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_motion_outlined, 
                        size: 14, 
                        color: theme.hintColor
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.tanni(courseModel.credits),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  
                  if (isRequired) CreditRequiredChip()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
