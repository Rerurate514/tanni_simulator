import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_limit_group.freezed.dart';
part 'credit_limit_group.g.dart';

@freezed
sealed class CreditLimitGroupModel with _$CreditLimitGroupModel {
  const factory CreditLimitGroupModel({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'course_ids') 
    required List<String> courseIds,
    @JsonKey(name: 'max_credits_allowed') 
    required int maxCreditsAllowed,
  }) = _CreditLimitGroupModel;

  factory CreditLimitGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CreditLimitGroupModelFromJson(json);
}
