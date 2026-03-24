import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';

List<CourseModel> joinCategoryAllCourse(CurriculumModel curriculum) {
  return curriculum.universityCurriculum[CategoryType.professional.index].courses + curriculum.universityCurriculum[CategoryType.general.index].courses;
}
