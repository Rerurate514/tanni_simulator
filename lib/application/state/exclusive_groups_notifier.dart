import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group_state.dart';
import 'package:tanni_simulator/domain/service/exclusive_groups_service.dart';

part 'exclusive_groups_notifier.g.dart';

@Riverpod(keepAlive: true)
class ExclusiveGroupsNotifier extends _$ExclusiveGroupsNotifier {
  @override
  List<ExclusiveGroupState> build() {
    final curriculumAsync = ref.watch(loadingCurriculumUsecaseProvider);

    return curriculumAsync.maybeWhen(
      data: (data) {
        if(data == null) return [];

        return data.exclusiveGroups.map(
          (eg) => ExclusiveGroupState.notSelected(
            group: eg
          )
        ).toList();
      },
      orElse: () => []
    );
  }

  void select(CourseModel selectedCourse) {
    final egService = ref.read(exclusiveGroupServiceProvider);
    state = egService.exclusiveIds(state, selectedCourse);
  }
}
