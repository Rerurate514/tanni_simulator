import 'package:flutter/animation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/entities/credit_limited_rule.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group_state.dart';

part 'course_card_state.freezed.dart';

@freezed
sealed class CourseCardState with _$CourseCardState {
  const factory CourseCardState({
    required bool isCreditsCompleted,
    required ExclusiveGroupState? eg,
    required Color activeColor,
    required List<CreditLimitRuleModel> clrs
  }) = _CourseCardState;
}
