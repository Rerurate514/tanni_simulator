# 単位管理アプリ用マスターデータ仕様書
本ドキュメントは、大学のカリキュラム、進級条件、および卒業要件を管理するためのYAMLマスターデータの構造と記述ルールを定義するものです。

## 0. データフォルダの所在
静的マスタは `assets/data/curriculum/` に配置し、ファイル名は `{DEPT}_{year}.yaml`（例: `T-2023.yaml`）とします。

## 1. データ構造の概要
データは以下の5つのセクションで構成されます。

1.  `metadata`: ファイルの適用対象（大学・学科・年度）を定義。
2.  `university_curriculum`: 科目ごとの基本情報（単位数、開講時期、属性）。
3.  `requirements`: 進級・卒業のための判定ロジック。
4.  `exclusive_groups`: 同時履修不可（排他的選択）科目の定義。
5.  `credit_limit_rules`: カテゴリごとに定義する単位数上限制約。
---

## 2. 各セクションの詳細仕様
### 2.1 metadata
データの適用範囲を定義します。

| フィールド | 型 | 内容 |
| :--- | :--- | :--- |
| `university` | string | 大学名 |
| `department` | string | 学科・専攻名 |
| `applicable_year` | int | 適用開始年度（例: 2024） |

### 2.2 university_curriculum
各科目の基本データです。`category` ごとにリスト化します。

| フィールド | 型 | 内容 |
| :--- | :--- | :--- |
| `id` | string | 一意の識別子（`prof-` 専門 / `gen-` 教養）。 |
| `name` | string | 科目名称。 |
| `is_required` | bool | `true`: 必修科目 / `false`: 選択科目。 |
| `credits` | int | 修得可能な単位数。 |
| `term` | int | 開講セメスター（後述の対応表参照）。 |

### 2.3 requirements
進級判定等のチェックポイントで満たすべき条件です。

* `must_have_course_ids`: 必須取得科目のIDリスト。
* `total_credits_required`: 必要最低合計単位数。
* `categories`: カテゴリ別の最低単位数や、カテゴリ内必修単位数の合計を指定。
  * カテゴリは`専門教育科目`と`教養教育科目`の二つになります。
  * 必ず、`専門教育科目`の進級要件を一番目に書いてください。記述例の順番に必ず沿ってください。

| フィールド               | 型  | 内容                                                                    |
| ----------------------- | ------ | ------------------------------------------------------------------------- |
| `category_name`         | string | `専門教育科目` または `教養教育科目`。                                                    |
| `min_credits`           | int    | そのカテゴリで最低限必要な合計単位数。                                                       |
| `must_have_course_ids`  | list   | 個別に指定する必須取得科目のIDリスト。                                                  |
| `check_all_is_required` | bool   | `true` の場合、マスタ内の当該カテゴリで `is_required: true` となっている全科目を自動的に必須取得対象とします。 |

### 2.4 exclusive_groups（排他制御）
「表象文化論」と「現代社会論」のように、どちらか一方しか履修できないルールを管理します。
* `course_ids` 内の科目を複数修得していても、UI上でどちらか一方しか選択できないようになります。

### 2.5 credit_limit_rules（単位上限制約）
「特別課外活動は6単位まで」といった制約を、集計カテゴリ単位で管理します。これにより、専門教育科目の集計時にどの制限を適用すべきかが明確になります。

|フィールド|型|内容|
|---|---|---|
|`category_name`|string|制約を適用する集計カテゴリ名（`専門教育科目` 等）。|
|`groups`|list|該当カテゴリに紐づく具体的な制限ルールのリスト。|

groups 内のフィールド
|フィールド|型|内容|
|---|---|---|
|`id`|string|制限ルールの一意識別子。|
|`name`|string|ルール名称（例：特別課外活動 上限）。|
|`description`|string|ユーザー向けの補足説明。|
|`course_ids`|list|合計単位数を算出する対象科目のIDリスト。|
|`max_credits_allowed`|int|そのグループ内で有効とみなす最大合計単位数。|


## 3. セメスター（term）の対応表

| 年次 | 前期（春） | 後期（秋） |
| :--- | :---: | :---: |
| 1年 | 1 | 2 |
| 2年 | 3 | 4 |
| 3年 | 5 | 6 |
| 4年 | 7 | 8 |
| 随時/特定不可 | 0 | 0 |

※院のカリキュラムは入れていません。PRpls

## 4. 記述例
```yaml
# ==========================================
# 1. メタデータ定義
# ==========================================
metadata:
  university: "東北工業大学"
  department: "情報通信工学科"
  applicable_year: 2024  # この年度の入学生から適用されるカリキュラムであることを示す

# ==========================================
# 2. カリキュラム本体（科目マスタ）
# ==========================================
university_curriculum:
  - category: "専門教育科目"
    courses:
      - id: "prof-01"
        name: "情報通信工学セミナーⅠ"
        is_required: true   # マスタ上の必修フラグ。check_all_is_required: true の時に対象となる
        credits: 1
        term: 1             # 1年次前期（春）
      - id: "prof-99"
        name: "特殊実験演習"
        is_required: false  # 卒業要件上は選択だが、進級判定で必須にしたい場合は後述の requirements で指定
        credits: 2
        term: 4             # 2年次後期（秋）

# ==========================================
# 3. 判定ロジック（進級・卒業要件）
# ==========================================
requirements:
  - id: "promotion_to_3rd_year"
    title: "3年次への進級条件"
    total_credits_required: 64  # 合計で64単位以上取得していることが大前提
    categories:
      # --- 専門科目の判定ルール ---
      - category_name: "専門教育科目"
        min_credits: 40         # 専門だけで40単位以上必要
        # 【重要】マスタで必修(is_required: true)になっている科目をすべて「不足科目」としてリストアップする
        check_all_is_required: true
        # マスタ上は選択科目だが、この「3年次進級」の時だけは個別に取得を義務付けたいIDを指定
        must_have_course_ids: ["prof-99"] 

      # --- 教養科目の判定ルール ---
      - category_name: "教養教育科目"
        min_credits: 16
        # 教養は「必修全取得」のルールがない（または手動で管理したい）場合は false にする
        check_all_is_required: false
        # 指定した特定の科目（例：英語やキャリア教育）のみを必須チェック対象とする
        must_have_course_ids: ["gen-01", "gen-02", "gen-03"]

# ==========================================
# 4. 特殊ルール（排他・上限）
# ==========================================
exclusive_groups:
  - id: "gen-group-culture-1"
    name: "表象文化論・現代社会論 選択"
    # どちらか一方しか卒業単位に含まれないルール（UI上で重複選択を防ぐ）
    course_ids: ["gen-11", "gen-12"]
    max_credits_allowed: 2

credit_limit_rules:
  - category_name: "専門教育科目"
    groups:
      - id: "limit-prof-extracurricular"
        name: "専門教育 特別課外活動"
        description: "特別課外活動Ⅰ〜Ⅵの合計で6単位まで算出可能"
        max_credits_allowed: 6
        course_ids: ["prof-61", "prof-62", "prof-63"]
      - id: "limit-prof-other-dept"
        name: "他学科・他大学科目"
        description: "他学科および他大学科目の合計で4単位まで算出可能"
        max_credits_allowed: 4
        course_ids: ["prof-67", "prof-68"]

  - category_name: "教養教育科目"
    groups:
      - id: "limit-gen-extracurricular"
        name: "教養教育 特別課外活動"
        description: "学際区分の特別課外活動の合計上限"
        max_credits_allowed: 4
        course_ids: ["gen-47", "gen-48"]
```

5. 運用上の注意点
* IDの一意性: id はアプリ内で主キーとして扱うため、重複は厳禁です。
* 型の一致: credits や term は必ず数値型（整数）で記述してください。
* 排他制御の適用: 基本的に授業時間が重複する科目や、大学側が「重複算入不可」と定めた科目に設定します。
* YAML構造が事前に定義されたものとちょっとでも違うと、全くアプリロジックが働かなくなります。
