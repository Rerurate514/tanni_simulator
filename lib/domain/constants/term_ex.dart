import 'package:tanni_simulator/l10n/app_localizations.dart';

extension TermExtension on int {
  String toTermName(AppLocalizations l10n) {
    return switch (this) {
      1 => l10n.term_1,
      2 => l10n.term_2,
      3 => l10n.term_3,
      4 => l10n.term_4,
      5 => l10n.term_5,
      6 => l10n.term_6,
      7 => l10n.term_7,
      8 => l10n.term_8,
      _ => '不明な学期',
    };
  }
}
