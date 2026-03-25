import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/domain/constants/category_type.dart';
import 'package:tanni_simulator/domain/constants/requirement_status.dart';
import 'package:tanni_simulator/domain/entities/requirement.dart';
import 'package:tanni_simulator/domain/utils/switch_by_categories_length.dart';

part 'requirement_credit_judge_service.g.dart';

@riverpod
RequirementCreditJudgeService requirementCreditJudgeService(Ref ref) {
  return const RequirementCreditJudgeService();
}

class RequirementCreditJudgeService {
  const RequirementCreditJudgeService();

  // total_credits_requiredを超えているかどうか
  bool isRequirementMet(RequirementModel requirement, int totalCredits) {
    if (requirement.totalCreditsRequired == null) return false;

    return totalCredits >= requirement.totalCreditsRequired!;
  }

  // categoriesの専門教養それぞれのmin_creditsを超えているか
  RequirementStatus checkRequirementStatus(
    RequirementModel requirement,
    int profCredits,
    int genCredits,
  ) {
    return switchByCategoriesLength<RequirementStatus>(
      requirement,
      () {
        return RequirementStatus.notExist;
      },
      (category, categoryType) {
        if (category.minCredits == 0) return RequirementStatus.notExist;
        switch (categoryType) {
          case CategoryType.professional:
            {
              final isExceedProfCredits = profCredits < category.minCredits;
              if (!isExceedProfCredits) {
                return RequirementStatus.professionalCreditShortage;
              }
            }
          case CategoryType.general:
            {
              final isExceedGenCredits = genCredits < category.minCredits;
              if (!isExceedGenCredits) {
                return RequirementStatus.generalCreditShortage;
              }
            }
        }

        return RequirementStatus.notExist;
      },
      (prof, gen) {
        final isExceedProfCredits = profCredits < prof.minCredits;
        final isExceedGenCredits = genCredits < gen.minCredits;

        if (isExceedProfCredits && isExceedGenCredits) {
          return RequirementStatus.bothCreditShortage;
        }
        if (isExceedProfCredits) {
          return RequirementStatus.professionalCreditShortage;
        }
        if (isExceedGenCredits) {
          return RequirementStatus.generalCreditShortage;
        }

        return RequirementStatus.fulfilled;
      },
    );
  }

  //決められた必修科目単位を超えているか
  bool isProfessionalRequirementMet(
    Ref ref,
    RequirementModel selectedRequirement,
    int profCredits,
  ) {
    return switchByCategoriesLength<bool>(
      selectedRequirement,
      () => true,
      (category, type) {
        if (type != CategoryType.professional) return true;
        return profCredits >= category.minCredits;
      },
      (prof, gen) {
        return profCredits >= prof.minCredits;
      },
    );
  }

  //決められた教養科目単位を超えているか
  bool isGeneralRequirementMet(
    Ref ref,
    RequirementModel selectedRequirement,
    int genCredits,
  ) {
    return switchByCategoriesLength<bool>(
      selectedRequirement,
      () => true,
      (category, type) {
        if (type != CategoryType.general) return true;
        return genCredits >= category.minCredits;
      },
      (prof, gen) {
        return genCredits >= gen.minCredits;
      },
    );
  }
}
