import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/entities/course.dart';

part 'missing_courses_provider.g.dart';

@riverpod
List<CourseModel> missingCourses(Ref ref) {
  final allCourses = ref.watch(courseListProvider);
  final currentRequirement = ref.watch(selectedRequirementProvider);
  if(currentRequirement == null ) return [];

  final mustIds = currentRequirement.mustHaveCourseIds ?? [];

  return allCourses.where((course) {
    return mustIds.contains(course.id) && !course.isCompleted;
  }).toList();
}
