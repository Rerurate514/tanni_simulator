import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';

part 'selected_requirement_notifier.g.dart';

@riverpod
class SelectedRequirementNotifier extends _$SelectedRequirementNotifier {
  @override
  RequirementModel? build() {
    return null;
  }

  void select(RequirementModel? requirement) {
    state = requirement;
  }
}
