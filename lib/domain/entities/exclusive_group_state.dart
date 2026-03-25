import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group.dart';

part 'exclusive_group_state.freezed.dart';
part 'exclusive_group_state.g.dart';

@freezed
sealed class ExclusiveGroupState with _$ExclusiveGroupState {
  factory ExclusiveGroupState.notSelected({
    required ExclusiveGroupModel group,
  }) = ExclusiveGroupNotSelected;

  factory ExclusiveGroupState.selected({
    required ExclusiveGroupModel group,
    required String selectedCourseId
  }) = ExclusiveGroupSelected;

  factory ExclusiveGroupState.fromJson(Map<String, dynamic> json) =>
      _$ExclusiveGroupStateFromJson(json);
}
