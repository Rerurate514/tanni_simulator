import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tanni_simulator/application/state/selected_requirement_notifier.dart';
import 'package:tanni_simulator/domain/service/credit_calculator_service.dart';
import 'package:tanni_simulator/l10n/app_localizations.dart';
import 'package:tanni_simulator/presentation/pages/home/providers/total_credit_provider.dart';

part 'summary_progress_provider.g.dart';

@riverpod
double summaryPercentage(Ref ref) {
  final total = ref.watch(totalCreditProvider);
  final target = ref.watch(selectedRequirementProvider);
  final service = ref.watch(creditCalculatorServiceProvider);

  if(target == null || target.totalCreditsRequired == null) return 0.0;
  return service.calculatePercentage(total, target.totalCreditsRequired!);
}

@riverpod
String summaryLabel(Ref ref, BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final total = ref.watch(totalCreditProvider);
  final target = ref.watch(selectedRequirementProvider)?.totalCreditsRequired;

  if (target == null) return l10n.promotion_not_required_credits(total);
  return l10n.tanni_count(total, target);
}
