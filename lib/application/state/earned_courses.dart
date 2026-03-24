import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/domain/entities/course.dart';

part 'earned_courses.g.dart';

@riverpod
List<CourseModel> earnedCourses(Ref ref) {
  final allCourses = ref.watch(courseListProvider);
  
  return allCourses.where((c) => c.isCompleted).toList();
}
