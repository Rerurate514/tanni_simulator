import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/domain/entities/course.dart';

part 'is_credit_completed_provider.g.dart';

@riverpod
bool isCreditCompleted(Ref ref, CourseModel targetCourse) {
  final courses = ref.watch(courseListProvider);
  return (courses.firstWhere((course) => course.id == targetCourse.id)).isCompleted;
}
