import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group_state.dart';
import 'package:tanni_simulator/domain/service/exclusive_groups_service.dart';

part 'course_completion_service.g.dart';

@riverpod
CourseCompletionService courseCompletionService(Ref ref) {
  return const CourseCompletionService();
}

class CourseCompletionService {
  const CourseCompletionService();

  List<CourseModel> applyExclusiveRules({
    required List<CourseModel> original,
    required CourseModel targetModel,
    required List<ExclusiveGroupState> egs,
    required ExclusiveGroupService egService,
    required void Function(CourseModel matchedCourse) onMatched
  
  }) {
    return original.map((course) {
      for (final eg in egs) {
        final isContain = egService.isCourseContains(eg, course);
        if(!isContain || !eg.group.courseIds.contains(targetModel.id)) continue;

        if(targetModel.id == course.id) {
          onMatched(course);
        } else {
          return course.copyWith(isCompleted: false);
        }
      }
      if(targetModel.id != course.id) return course;
      
      return course.copyWith(isCompleted: !course.isCompleted);
    }).toList();
  }
}
