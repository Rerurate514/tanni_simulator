import 'package:freezed_annotation/freezed_annotation.dart';

part 'exclusive_group.freezed.dart';
part 'exclusive_group.g.dart';

@freezed
sealed class ExclusiveGroupModel with _$ExclusiveGroupModel {
  const factory ExclusiveGroupModel({
    required String id,
    required String name,
    @JsonKey(name: 'course_ids') required List<String> courseIds,
  }) = _ExclusiveGroupModel;

  factory ExclusiveGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ExclusiveGroupModelFromJson(json);
}
