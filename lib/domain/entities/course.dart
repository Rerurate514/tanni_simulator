import 'package:freezed_annotation/freezed_annotation.dart';

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
    @Default(false)
    bool isCompleted
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);
}
