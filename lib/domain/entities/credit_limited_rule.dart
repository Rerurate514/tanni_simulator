import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_limited_rule.freezed.dart';
part 'credit_limited_rule.g.dart';

@freezed
sealed class CreditLimitRuleModel with _$CreditLimitRuleModel {
  const factory CreditLimitRuleModel({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'course_ids') required List<String> courseIds,
    @JsonKey(name: 'max_credits_allowed') required int maxCreditsAllowed,
  }) = _CreditLimitRuleModel;

  factory CreditLimitRuleModel.fromJson(Map<String, dynamic> json) =>
      _$CreditLimitRuleModelFromJson(json);
}
