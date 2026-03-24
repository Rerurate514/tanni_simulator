import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/course_list_notifier.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';

part 'total_credit_provider.g.dart';

@riverpod
int totalCredit (Ref ref) {
  final courses = ref.watch(courseListProvider);
  final service = ref.watch(creditCalculatorServiceProvider);

  return service.calculateTotal(courses); 
}
