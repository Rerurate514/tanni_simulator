import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';

class DeselectAllButton extends HookConsumerWidget {
  const DeselectAllButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      elevation: 4,
      child: IconButton(
        onPressed: () {
          ref.read(courseListProvider.notifier).deselectAll();
        }, 
        icon: const Icon(
          Icons.delete,
          size: 32,
        )
      )
    );
  }
}
