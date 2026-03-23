import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/infrastructure/models/course.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
sealed class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String category,
    required List<CourseModel> courses,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}
