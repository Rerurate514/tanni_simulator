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

extension CourseListEx on List<CourseModel> {
  int get allCredits => fold(0, (sum, course) => sum + course.credits);
  CourseModel findCourceById(String id) {
    return firstWhere((cource) => cource.id == id);
  }
}
