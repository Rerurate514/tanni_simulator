import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';

part 'credit_calculator_service.g.dart';

@riverpod
CreditCalculatorService creditCalculatorService(Ref ref) {
  return const CreditCalculatorService();
}

class CreditCalculatorService {
  const CreditCalculatorService();

  List<CourseModel> getEarnedCredits(List<CourseModel> courses) {
    return courses.where((course) => course.isCompleted).toList();
  }

  int getEarnedCategoryCredits(
    List<CourseModel> courses,
    CategoryType categoryType,
  ) {
    return courses
        .where((course) => course.category == categoryType)
        .where((course) => course.isCompleted)
        .fold(0, (sum, course) => sum + course.credits);
  }

  int calculateTotal(List<CourseModel> courses) {
    return courses
        .where((course) => course.isCompleted)
        .fold(0, (sum, course) => sum + course.credits);
  }
}
