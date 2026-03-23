import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tanni_simulator/domain/entities/category.dart';
import 'package:tanni_simulator/domain/entities/credit_limit_group.dart';
import 'package:tanni_simulator/domain/entities/exclusive_group.dart';
import 'package:tanni_simulator/domain/entities/metadata.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';

part 'curriculum.freezed.dart';
part 'curriculum.g.dart';

@freezed
sealed class CurriculumModel with _$CurriculumModel {
  const factory CurriculumModel({
    required MetadataModel metadata,
    @JsonKey(name: 'university_curriculum') 
    required List<CategoryModel> universityCurriculum,
    required List<RequirementModel> requirements,
    @JsonKey(name: 'exclusive_groups') 
    required List<ExclusiveGroupModel> exclusiveGroups,
    @JsonKey(name: 'credit_limit_groups') 
    required List<CreditLimitGroupModel> creditLimitGroups,
  }) = _CurriculumModel;

  factory CurriculumModel.fromJson(Map<String, dynamic> json) =>
      _$CurriculumModelFromJson(json);
}
