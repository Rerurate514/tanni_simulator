import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';

part 'requirement_category.freezed.dart';
part 'requirement_category.g.dart';

@freezed
sealed class RequirementCategoryModel with _$RequirementCategoryModel {
  const factory RequirementCategoryModel({
    @JsonKey(name: 'category_name') required String categoryName,
    required CategoryType category,
    @JsonKey(name: 'min_credits') @Default(0) int minCredits,
    @JsonKey(name: 'must_have_course_ids')
    @Default([])
    List<String> mustHaveCourseIds,
    @JsonKey(name: 'required_is_required_credits')
    int? requiredIsRequiredCredits,
    @JsonKey(name: 'check_all_is_required')
    @Default(false)
    bool isCheckedAllRequired,
  }) = _RequirementCategoryModel;

  factory RequirementCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementCategoryModelFromJson(json);
}
