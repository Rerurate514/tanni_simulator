import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/exclusive_groups_notifier.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/service/course_completion_service.dart';
import 'package:tanni_simulator/domain/service/exclusive_groups_service.dart';

part 'course_list_notifier.g.dart';

@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  @override
  List<CourseModel> build() {
    final curriculumAsync = ref.watch(loadingCurriculumUsecaseProvider);

    return curriculumAsync.maybeWhen(
      data: (data) {
        if (data == null) return [];

        return [
          ...data.universityCurriculum[CategoryType.professional.index].courses,
          ...data.universityCurriculum[CategoryType.general.index].courses,
        ];
      },
      orElse: () => [],
    );
  }

  void toggle(CourseModel targetModel) {
    final egs = ref.read(exclusiveGroupsProvider);
    final egService = ref.read(exclusiveGroupServiceProvider);
    final ccService = ref.read(courseCompletionServiceProvider);

    state = ccService.applyExclusiveRules(
      original: state,
      targetModel: targetModel,
      egs: egs,
      egService: egService,
      onMatched: (matchedCourse) {
        ref.read(exclusiveGroupsProvider.notifier).select(matchedCourse);
      },
    );
  }

  void deselectAll() {
    state = state.map((course) => course.copyWith(isCompleted: false)).toList();
  }
}
