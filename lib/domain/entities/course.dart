import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
sealed class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    required String name,
    @JsonKey(name: 'is_required') required bool isRequired,
    required int credits,
    required int term,
    required CategoryType category,
    @Default(false) bool isCompleted,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

extension CourseListExCM on List<CourseModel> {
  int get allCredits => fold(0, (sum, course) => sum + course.credits);
  CourseModel findCourseById(String id) {
    return firstWhere((course) => course.id == id);
  }
}

CourseModel? convertCourseById(List<CourseModel> allCourses, String id) {
  return allCourses.firstWhereOrNull((course) => course.id == id);
}

extension CourseListExStr on List<String> {
  List<CourseModel> toCourses(List<CourseModel> allCourses) {
    return map((id) => convertCourseById(allCourses, id))
        .whereType<CourseModel>()
        .toList();
  }
}
