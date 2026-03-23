import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';

part 'course_list_notifier.g.dart';

@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  @override
  List<CourseModel> build() {
    final curriculumAsync = ref.watch(loadingCurriculumUsecaseProvider);

    return curriculumAsync.maybeWhen(
      data: (CurriculumModel? data) {
        if(data == null) return [];

        return [
          ...data.universityCurriculum[CategoryType.professional.index].courses, 
          ...data.universityCurriculum[CategoryType.general.index].courses
        ];
      },
      orElse: () => []
    );
  }

  void toggle(CourseModel targetModel) {
    state = state.map((course) {
      if(targetModel.id == course.id) {
        return course.copyWith(isCompleted: !course.isCompleted);
      }
      return course;
    }).toList();
  }
}
