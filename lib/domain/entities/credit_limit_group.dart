import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/entities/credit_limited_rule.dart';

part 'credit_limit_group.freezed.dart';
part 'credit_limit_group.g.dart';

@freezed
sealed class CreditLimitGroupModel with _$CreditLimitGroupModel {
  const factory CreditLimitGroupModel({
    @JsonKey(name: 'category_name') required String categoryName,
    required List<CreditLimitRuleModel> groups,
  }) = _CreditLimitGroupModel;

  factory CreditLimitGroupModel.fromJson(Map<String, dynamic> json) =>
      _$CreditLimitGroupModelFromJson(json);
}
