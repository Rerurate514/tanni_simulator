import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/entities/course.dart';

part 'credit_calculator_service.g.dart';

@riverpod
CreditCalculatorService creditCalculatorService(Ref ref) {
  return const CreditCalculatorService();
}

class CreditCalculatorService {
  const CreditCalculatorService();

  List<CourseModel> getEarnedCredits(List<CourseModel> courses) {
    return courses
    .where((course) => course.isCompleted)
    .toList();
  }

  int calculateTotal(List<CourseModel> courses) {
    return courses
    .where((course) => course.isCompleted)
    .fold(0, (sum, course) => sum + course.credits);
  }

  double calculatePercentage(int totalCredits, int targetCredits) {
    final percentage = totalCredits / targetCredits;
    return percentage >= 1.0 ? 1.0 : percentage;
  }
}
