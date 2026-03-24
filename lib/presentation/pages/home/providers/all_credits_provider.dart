import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';

part 'all_credits_provider.g.dart';

@riverpod
int allCredits(Ref ref) {
  final courses = ref.watch(courseListProvider);
  return courses.fold(0, (sum, course) => sum + course.credits);
}
