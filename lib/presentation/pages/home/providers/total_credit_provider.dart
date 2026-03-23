import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';

part 'total_credit_provider.g.dart';

@riverpod
int totalCredit (Ref ref) {
  final courses = ref.watch(courseListProvider);
  return courses
    .where((course) => course.isCompleted)
    .fold(0, (sum, course) => sum + course.credits);
}
