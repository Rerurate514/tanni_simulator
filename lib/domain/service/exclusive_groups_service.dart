import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group_state.dart';

part 'exclusive_groups_service.g.dart';

@riverpod
ExclusiveGroupService exclusiveGroupService(Ref ref) {
  return const ExclusiveGroupService();
}

class ExclusiveGroupService {
  const ExclusiveGroupService();

  bool isCourseContains(
    ExclusiveGroupState eg,
    CourseModel selectedCourse,
  ) {
    final ids = eg.group.courseIds;
    return ids.contains(selectedCourse.id);
  }

  ExclusiveGroupState? findGroupByCourse(
    List<ExclusiveGroupState> egs,
    CourseModel selectedCourse,
  ) {
    for (final eg in egs) {
      if(isCourseContains(eg, selectedCourse)) return eg;
    }

    return null;
  }

  List<ExclusiveGroupState> exclusiveIds(
    List<ExclusiveGroupState> originalEgs,
    CourseModel selectedCourse,
  ) {
    return originalEgs.map((eg) {
      if (!isCourseContains(eg, selectedCourse)) return eg;
      if (
          eg is ExclusiveGroupSelected &&
          eg.selectedCourseId == selectedCourse.id
        ) {
        return ExclusiveGroupNotSelected(group: eg.group);
      }
      return ExclusiveGroupSelected(
        group: eg.group,
        selectedCourseId: selectedCourse.id,
      );
    }).toList();
  }
}
