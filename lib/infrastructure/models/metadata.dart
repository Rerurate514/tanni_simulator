import 'package:freezed_annotation/freezed_annotation.dart';

part 'metadata.freezed.dart';
part 'metadata.g.dart';

@freezed
sealed class MetadataModel with _$MetadataModel {
  const factory MetadataModel({
    required String university,
    required String department,
    @JsonKey(name: 'applicable_year') required int applicableYear,
  }) = _MetadataModel;

  factory MetadataModel.fromJson(Map<String, dynamic> json) => _$MetadataModelFromJson(json);
}
