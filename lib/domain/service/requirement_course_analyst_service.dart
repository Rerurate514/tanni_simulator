import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/entities/course.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';
import 'package:tanni_simulator/domain/utils/switch_by_categories_length.dart';

part 'requirement_course_analyst_service.g.dart';

@riverpod
RequirementCourseAnalystService requirementCourseAnalystService(Ref ref) {
  return const RequirementCourseAnalystService();
}

class RequirementCourseAnalystService {
  const RequirementCourseAnalystService();

  // categoriesのcategoryのmust_have_course_idsに書いてある単位を履修しているか
  // 帰り値は履修していない授業IDsが返される。
  List<CourseModel> getMissingCourses(
    RequirementModel requirement,
    List<CourseModel> earnedCourses,
    List<CourseModel> allCourses,
  ) {
    final earnedIds = earnedCourses.map((c) => c.id).toSet();
    return switchByCategoriesLength<List<CourseModel>>(
      requirement,
      () {
        return [];
      },
      (category, categoryType) {
        final ids = category.mustHaveCourseIds;
        final missingIds = ids.where((id) => !earnedIds.contains(id)).toSet();

        return allCourses
            .where((course) => missingIds.contains(course.id))
            .toList();
      },
      (prof, gen) {
        final allMustIds = [
          ...prof.mustHaveCourseIds,
          ...gen.mustHaveCourseIds,
        ];
        final missingIds = allMustIds
            .where((id) => !earnedIds.contains(id))
            .toSet();

        return allCourses
            .where((course) => missingIds.contains(course.id))
            .toList();
      },
    );
  }

  //check_all_is_requiredがtrueの時に、全ての必修科目を履修しているか
  List<CourseModel>? checkAllRequiredSubjectsMet(
    RequirementModel requirement,
    List<CourseModel> earnedCourses,
    List<CourseModel> allCourses,
  ) {
    return switchByCategoriesLength<List<CourseModel>?>(
      requirement,
      () => null,
      (category, categoryType) {
        if (!category.isCheckedAllRequired) return null;

        final earnedIds = earnedCourses.map((c) => c.id).toSet();

        return allCourses
            .where(
              (c) =>
                  c.category == categoryType &&
                  c.isRequired &&
                  !earnedIds.contains(c.id),
            )
            .toList();
      },
      (prof, gen) {
        final earnedIds = earnedCourses.map((c) => c.id).toSet();
        final missingCourses = <CourseModel>[];

        if (prof.isCheckedAllRequired) {
          missingCourses.addAll(
            allCourses.where(
              (c) =>
                  c.category == CategoryType.professional &&
                  c.isRequired &&
                  !earnedIds.contains(c.id),
            ),
          );
        }

        if (gen.isCheckedAllRequired) {
          missingCourses.addAll(
            allCourses.where(
              (c) =>
                  c.category == CategoryType.general &&
                  c.isRequired &&
                  !earnedIds.contains(c.id),
            ),
          );
        }

        return missingCourses.isEmpty ? [] : missingCourses;
      },
    );
  }
}
