import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/entities/requirement_category.dart';

part 'requirement.freezed.dart';
part 'requirement.g.dart';

@freezed
sealed class RequirementModel with _$RequirementModel {
  const factory RequirementModel({
    required String id,
    required String title,
    @JsonKey(name: 'total_credits_required') int? totalCreditsRequired,
    @Default([]) List<RequirementCategoryModel> categories,
    @JsonKey(name: 'must_have_course_ids') List<String>? mustHaveCourseIds,
  }) = _RequirementModel;

  factory RequirementModel.fromJson(Map<String, dynamic> json) => _$RequirementModelFromJson(json);
}
