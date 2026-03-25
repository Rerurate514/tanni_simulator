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
    ExclusiveGroupState exclusiveGroups,
    CourseModel selectedCourse,
  ) {
    final ids = exclusiveGroups.group.courseIds;
    return ids.contains(selectedCourse.id);
  }

  List<ExclusiveGroupState> exclusiveIds(
    List<ExclusiveGroupState> originalEgs,
    CourseModel selectedCourse,
  ) {
    return originalEgs.map((eg) {
      if (!isCourseContains(eg, selectedCourse)) return eg;
      if (
          eg is ExclusiveGroupSelected &&
          eg.selectedCourceId == selectedCourse.id
        ) {
        return ExclusiveGroupNotSelected(group: eg.group);
      }
      return ExclusiveGroupSelected(
        group: eg.group,
        selectedCourceId: selectedCourse.id,
      );
    }).toList();
  }
}
