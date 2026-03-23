# 単位管理アプリ用マスターデータ仕様書

本ドキュメントは、大学のカリキュラム、進級条件、および卒業要件を管理するためのYAMLマスターデータの構造と記述ルールを定義するものです。

## 0. データフォルダの所在
静的マスタは `assets/data/curriculum/` に配置し、ファイル名は `{dept}_{year}.yaml`（例: `T-2023.yaml`）とします。

## 1. データ構造の概要
データは以下の5つのセクションで構成されます。

1.  **`metadata`**: ファイルの適用対象（大学・学科・年度）を定義。
2.  **`university_curriculum`**: 科目ごとの基本情報（単位数、開講時期、属性）。
3.  **`requirements`**: 進級・卒業のための判定ロジック。
4.  **`exclusive_groups`**: 同時履修不可（排他的選択）科目の定義。
5.  **`credit_limit_groups`**: 複数科目の合計単位数に上限がある場合の制約ルール。

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

* **`must_have_course_ids`**: 必須取得科目のIDリスト。
* **`total_credits_required`**: 必要最低合計単位数。
* **`categories`**: カテゴリ別の最低単位数や、カテゴリ内必修単位数の合計を指定。

### 2.4 exclusive_groups（排他制御）
「表象文化論」と「現代社会論」のように、どちらか一方しか卒業単位に算入できないルールを管理します。
* `course_ids` 内の科目を複数修得していても、合計計算時は `max_credits_allowed`（通常は1科目分の単位数）を上限としてカウントします。

### 2.5 credit_limit_groups（単位上限制約）
特別課外活動や他学科科目のように、「合計○単位まで算入可能」というルールを管理します。
* `max_credits_allowed`: 該当グループ内で有効な最大単位数（例：特別課外活動なら6）。

## 3. セメスター（term）の対応表

| 年次 | 前期（春） | 後期（秋） |
| :--- | :---: | :---: |
| 1年 | 1 | 2 |
| 2年 | 3 | 4 |
| 3年 | 5 | 6 |
| 4年 | 7 | 8 |
| 随時/特定不可 | 0 | 0 |

## 4. 記述例
```yaml
metadata:
  university: "東北工業大学"
  department: "情報通信工学科"
  applicable_year: 2024

university_curriculum:
  - category: "専門教育科目"
    courses:
      - id: "prof-01"
        name: "情報通信工学セミナーⅠ"
        is_required: true
        credits: 1
        term: 1

requirements:
  - id: "promotion_to_4th_year"
    title: "4年次への進級条件"
    total_credits_required: 100
    categories:
      - category_name: "専門教育科目"
        min_credits: 76
        must_have_course_ids: ["prof-27", "prof-36", "prof-45"]

exclusive_groups:
  - id: "gen-group-culture-1"
    name: "表象文化論・現代社会論 選択"
    course_ids: ["gen-11", "gen-12"]
    max_credits_allowed: 2

credit_limit_groups:
  - id: "limit-prof-extracurricular"
    name: "専門教育 特別課外活動"
    course_ids: ["prof-61", "prof-62", "prof-63", "prof-64", "prof-65", "prof-66"]
    max_credits_allowed: 6
```

5. 運用上の注意点
* IDの一意性: id はアプリ内で主キーとして扱うため、重複は厳禁です。
* 型の一致: credits や term は必ず数値型（整数）で記述してください。
* 排他制御の適用: 基本的に授業時間が重複する科目や、大学側が「重複算入不可」と定めた科目に設定します。
