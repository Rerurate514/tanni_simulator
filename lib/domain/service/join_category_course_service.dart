import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';

part 'join_category_course_service.g.dart';

@riverpod 
JoinCategoryCourseService joinCategoryAllCourse (Ref ref) {
  return const JoinCategoryCourseService();
}

class JoinCategoryCourseService {
  const JoinCategoryCourseService();

  List<CourseModel> joinCategory(CurriculumModel curriculum) {
    return curriculum
            .universityCurriculum[CategoryType.professional.index]
            .courses +
        curriculum.universityCurriculum[CategoryType.general.index].courses;
  }
}
