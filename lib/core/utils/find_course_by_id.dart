import 'package:tanni_simulator/domain/entities/course.dart';

CourseModel findCourceById(List<CourseModel> allCourses, String id) {
  return allCourses.firstWhere((cource) => cource.id == id);
}
