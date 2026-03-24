import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/requirement/requirement_conditions_providers.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';

part 'missing_courses_list_provider.g.dart';

@riverpod
List<CourseModel> missingCoursesList(Ref ref, RequirementModel selectedRequirement, CurriculumModel curriculum) {
  final mustCourses = ref.watch(missingCoursesProvider(selectedRequirement, curriculum));
  final allRequiredCourses = ref.watch(checkAllRequiredSubjectsMetProvider(selectedRequirement, curriculum));

  if(allRequiredCourses == null) return mustCourses;

  return (mustCourses + allRequiredCourses).toSet().toList();
}
