# tanni_simulator
大学の単位修得状況シミュレーターです。複雑な進級・卒業要件を整理して、履修計画を立てやすくすることを目指しています。

## 各コンポーネント解説
### セレクタの説明
ユーザーが自分の所属や目標とする進級年次を選択するエリアです。

#### 年度・学科
`curriculum.metadata` から取得した情報を表示します。
年度・学科にはyamlの数だけ表示されます。

<img width="1158" height="100" alt="image" src="https://github.com/user-attachments/assets/4b9bd12a-b45d-4c3b-9ee1-581b260999b0" />

このセレクタで使用するyamlを選択するまで、これ以降のコンポーネントは表示されません。

<img width="1178" height="134" alt="image" src="https://github.com/user-attachments/assets/365f905a-1a09-44ad-bb61-82fecad80f08" />

#### 進級条件
`curriculum.requirements` のリストから選択します。
yamlの`requirements`の各カテゴリずつセレクタに表示されます。

<img width="403" height="85" alt="image" src="https://github.com/user-attachments/assets/54e1efad-b3a5-4495-8e1b-54c93dc4f69d" />

<img width="449" height="214" alt="image" src="https://github.com/user-attachments/assets/3b943db5-b789-43dd-80c9-ff3e132d4c89" />

### サマリ
現在の進捗を視覚的に表示するカードです。
単なる合計ではなく、後述する「上限制御グループ」によって「卒業/進級に有効な単位のみ」がプログレスバーに反映されます。
yamlの`metadata`で定義される年度や学科、学校が表示されます。

<img width="1553" height="266" alt="image" src="https://github.com/user-attachments/assets/3e2c6e1d-3f4a-43d5-bb44-2fb6d73efd64" />

さらに、現在取得している単位の進捗を反映するプログレスバーも表示します。
これは要件チェックも含んでいて、yamlの`requirements`の各要件に`total_credits_required`が設定されているなら、その進捗と進級に必要な最低単位に対する修了割合も反映されます。画像では`total_credits_required: 124`の進級条件を選択しているので、`n / 124 単位`と表示されています。

<img width="1523" height="118" alt="image" src="https://github.com/user-attachments/assets/1b961cf6-4957-4604-8476-5f733457390a" />

### 要件チェック
進級判定の詳細をリスト表示します。
合計単位数、カテゴリ別単位数、必修科目の履修状況を個別に判定し、すべてクリアで「進級可能」と表示します。

<img width="2514" height="587" alt="image" src="https://github.com/user-attachments/assets/a14dd72f-7c20-4966-a0e0-427de5e72982" />

ここにはyamlで定義される細かい進級条件をクリアしているかどうかを表示します。
- 専門と共用の合計最低履修単位を超えているか
- 専門の最低履修単位を超えているか
- 教養の最低履修単位を超えているか
- 要件で定められる単位を履修しているか

もし、yamlの各要件のカテゴリで`check_all_is_required`が`true`の場合。
それまで履修していない必修科目をすべて表示します。

<img width="1520" height="215" alt="image" src="https://github.com/user-attachments/assets/b27a95b8-4639-4951-be1b-46b156c4c679" />

これは卒業の際にすべての必修科目を修了している必要があるためです。

<img width="255" height="83" alt="image" src="https://github.com/user-attachments/assets/142cf923-d6e3-41e0-8686-a5952faaefb5" />

### 単位選択テーブル
各科目をグリッド状に配置した、本アプリのメイン操作エリアです。

<img width="1680" height="496" alt="image" src="https://github.com/user-attachments/assets/c9c66e9f-3939-4621-a307-a3d786215d23" />

#### カードの説明
科目名、単位数、および特殊な制限状況を表示します。クリックすることで `isCompleted` 状態を反転させます。

<img width="149" height="93" alt="image" src="https://github.com/user-attachments/assets/093862ea-c103-46f1-8cd4-71545bc5223f" />

#### 各ラベルの説明
各科目に付与されるチップは、YAMLの以下の設定に基づいています。

##### 必修科目
`courses` 内の `is_required: true`になっている場合「必修」ラベルがつきます。
`is_required: true`の科目については`requirement`のカテゴリで`check_all_is_required: true`になっている場合、以下のように要件チェックカードに表示されます。
これは卒業の際などに必修科目が全て修了済みになっている必要があるためです。

<img width="177" height="94" alt="image" src="https://github.com/user-attachments/assets/274ce805-0eff-4f0c-b7ca-5cba8297d484" />

##### 排他制御グループ
yamlの`exclusive_groups`に各グループが決められます。
「AかBどちらか片方しか授業が履修できない」科目に表示されます。片方を選択すると、もう一方が自動で無効化される仕組みです。

<img width="291" height="120" alt="image" src="https://github.com/user-attachments/assets/403119aa-f1b1-49e0-bf5c-1c2688d5e8fe" />

これは例えば、 以下の画像の「表象文化論・現代社会論」は同時刻の授業のため、同時に履修できません。その状況をこのラベルで反映しています。

<img width="600" height="125" alt="image" src="https://github.com/user-attachments/assets/7f5de00e-2b96-4c01-9ae8-a6d5fab6dfd2" />

##### 上限制御グループ
yamlの`credit_limit_rules`にて、その各ルールが定められます。
特別課外活動は6単位まで」といったルールを適用します。上限を超えて取得しても、サマリと要件チェックの「有効単位」には加算されない旨を説明します。

<img width="352" height="124" alt="image" src="https://github.com/user-attachments/assets/4f7f3aa9-dbd5-4a47-b60d-cae8770a9f54" />

例えば、以下のyamlの時、
```yaml
credit_limit_rules:
  - category_name: "専門教育科目"
    groups:
      - id: "limit-prof-extracurricular"
        name: "専門教育 特別課外活動"
        description: "特別課外活動Ⅰ〜Ⅵの合計で6単位まで算出可能"
        max_credits_allowed: 6
        course_ids: ["prof-61", "prof-62", "prof-63", "prof-64", "prof-65", "prof-66"]
```

そして以下の選択状態の時、

<img width="1552" height="601" alt="image" src="https://github.com/user-attachments/assets/c21f33ab-2fbd-47a3-868c-c85c8fc579c0" />

画像では、`["prof-61", "prof-62", "prof-63", "prof-64", "prof-65", "prof-66"]`がすべて選択されていますが、サマリのプログレスバーには6単位と表示されています。本来なら(1+1+1+2+2+2)で9単位と表示・加算されるべきですが、これがルールによって制限されています。制限される値は`max_credits_allowed`にて決まります。このグループは`max_credits_allowed: 6`となっているので6単位までになります。

これは学生便覧にもその旨が記述されています。

<img width="545" height="179" alt="image" src="https://github.com/user-attachments/assets/7a600192-8064-4e0b-a73d-83301706c0db" />

### 単位全消し
入力したデータをリセットし、別の進級シミュレーションを最初からやり直すための機能です。

<img width="136" height="106" alt="image" src="https://github.com/user-attachments/assets/459f54c1-bbff-4736-8a88-f120716f0690" />

内部的には`deselectAll` 関数を実行しているだけです。

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

# l10n生成
flutter gen-l10n

# 静的解析
flutter analyze
```

## 注意事項
YAML構造が定義と少しでも異なると正しく動作しません。更新後は `flutter analyze` でエラーがないか確認してください。

## AIに手伝ってもらったこと
- マスタデータ項目提案
- Entitiesクラス設計
- UIのリファクタ
- 各クラスがアーキテクチャに合致したかどうか
- YAMLのmapパース
