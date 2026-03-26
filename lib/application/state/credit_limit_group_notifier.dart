import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/usecase/loading_curriculum_usecase.dart';
import 'package:tanni_simulator/domain/entities/credit_limit_group.dart';

part 'credit_limit_group_notifier.g.dart';

@riverpod
class CreditLimitGroupNotifier extends _$CreditLimitGroupNotifier {
  @override
  List<CreditLimitGroupModel> build() {
    final curriculumAsync = ref.watch(loadingCurriculumUsecaseProvider);

    return curriculumAsync.maybeWhen(
      data: (data) {
        if(data == null) return [];

        return data.creditLimitGroups;
      },
      orElse: () => []
    );
  }
}
