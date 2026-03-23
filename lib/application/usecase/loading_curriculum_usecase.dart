import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/curriculumn_type.dart';
import 'package:tanni_simulator/domain/entities/curriculum.dart';
import 'package:tanni_simulator/infrastructure/repositories/yaml_repository.dart';

part 'loading_curriculum_usecase.g.dart';

@riverpod
class LoadingCurriculumUsecase extends _$LoadingCurriculumUsecase {
  @override
  FutureOr<CurriculumModel?> build() async {
    return null;
  }

  Future<void> selectCurriculum(CurriculumType type) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(yamlRepositoryProvider);
      final map = await repo.loadFromAssets(type.path);
      return CurriculumModel.fromJson(map);
    });
  }
}
