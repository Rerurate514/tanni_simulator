# tanni_simulator
大学の単位修得状況シミュレーターです。複雑な進級・卒業要件を整理して、履修計画を立てやすくすることを目指しています。

## 主な機能
- 単位管理: セメスターごとに並んだ科目カードをタップして、修得状況を切り替えられます。
- 要件チェック: 選んだ進級・卒業条件をもとに、不足単位や未履修科目をその場で確認できます。
- カリキュラム定義: YAML形式で学科ごとの科目情報や算出ルール（排他制御、算入上限など）を記述します。

## アーキテクチャ
Layered Architectureで構成し、Riverpodで状態管理しています。

- Domain: エンティティ（Course, Requirement）と判定ロジック
- Application: Riverpodによる状態保持とユースケースの実装
- Infrastructure: YAMLリポジトリとローカルDB（Drift）によるデータ永続化
- Presentation: Flutter Hooks / Riverpodを使ったUIコンポーネント

## マスターデータ仕様
カリキュラムデータは `assets/data/curriculum/` 以下のYAMLファイルで管理します。

### 主な設定項目
- `check_all_is_required: true` : マスタ内の `is_required: true` 科目を必須チェック対象にします。
- `exclusive_groups` : どちらか一方のみ算入する排他制御。
- `credit_limit_groups` : 特別課外活動などの算入上限制御。

詳細は [docs/MASTER_DATA_GUIDE.md](https://github.com/Rerurate514/tanni_simulator/blob/main/docs/MASTER_DATA_GUIDE.md) を参照してください。

## 開発者向け情報
### 推奨環境
- Flutter: 3.29.0 以上
- Dart: 3.6.0 以上
- Linter: `very_good_analysis`（Line length: 80）

### セットアップ
```bash
# 依存関係の解決
flutter pub get

# コード生成（freezed, riverpod_generator, drift）
dart run build_runner build --delete-conflicting-outputs

# 静的解析
flutter analyze
```

## 注意事項
YAML構造が定義と少しでも異なると正しく動作しません。更新後は `flutter analyze` でエラーがないか確認してください。
