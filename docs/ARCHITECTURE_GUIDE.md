# アーキテクチャ解説
まず、ディレクトリ構造は以下のようになります。
```
lib/
├── application/
│   ├── credit/
│   ├── requirement/
│   ├── state/
│   └── usecase/
├── core/
│   └── utils/
├── domain/
│   ├── constants/
│   ├── entities/
│   ├── repositories/
│   ├── service/
│   └── utils/
├── infrastructure/
│   └── repositories/
├── l10n/ 
│   └── app.ja.arb
├── presentation/
│   ├── pages/
│   │   └── home/
│   │       ├── components/
│   │       │   ├── floating/
│   │       │   ├── selector/
│   │       │   ├── summary/
│   │       │   └── table/
│   │       ├── providers/
│   │       └── state/
│   │           └── table/
│   └── widgets/
└── main.dart
```

## application
アプリケーション層では、状態管理Notifierとdomain層のserviceを使用して保持するデータのprovider、usecaseが格納されています。
状態の保持と、UIからのアクションの受付を担当します。

### usecase
usecaseではユーザ捜査に応じてリポジトリを操作する必要がある時/serviceを複数用いて複雑な処理を行う際などに定義されます。

## プロバイダー群
UI層からserviceにはアクセスしません。
代わりにapplication層のproviderを通してアクセスします。

## core
### utils
このアプリに限定されない(=ドメインロジックを含まない)ロジックのみを格納します。

## domain
### constants
ドメインで使用する`enum`やドメイン文字列の拡張関数などを定義しています。

### entities
ドメインモデルを定義しています。今回はyamlをパースしたエンティティ群です。

### repositories
infrastructure層で使用するリポジトリのインターフェースを定義します。

### service
詳細なドメインロジックを含むクラスをriverpodを通して配信します。
基本的に状態を持ちません。処理を行う際は必要なパラメータやドメインモデルを引数から受け取ります。

例えば、
```dart
@riverpod
CreditCalculatorService creditCalculatorService(Ref ref) {
  return const CreditCalculatorService();
}

class CreditCalculatorService {
  const CreditCalculatorService();

  int getEarnedCategoryCredits(
    List<CourseModel> courses,
    CategoryType categoryType,
  ) {
    return courses
        .where((course) => course.category == categoryType)
        .where((course) => course.isCompleted)
        .fold(0, (sum, course) => sum + course.credits);
  }

  int calculateTotalCreditsEarned(List<CourseModel> courses) {
    return courses
        .where((course) => course.isCompleted)
        .fold(0, (sum, course) => sum + course.credits);
  }
}
```
この`CreditCalculatorService`は修了済み合計単位を算出するというビジネスロジックを担当します。

## infrastructure
### repositories
domain層で定義されたリポジトリインターフェースを具象します。

## l10n
このアプリは文言を統一管理するためにl10nを用います。

## presentation
presentationにはUI部品やそれに関連するクラスやproviderを定義します。
### pages
pagesは表示するページごとにディレクトリが作成されます。
#### home
##### components
pageは以下のcomponentsディレクトリには、他ページで使用しないような、特定の画面に紐付いたウィジェットをこのディレクトリに配置します。
私が共通コンポーネントをウィジェットと呼ぶのに対し、特定の画面でしか使用しないウィジェットをコンポーネントと呼んでいるだけです。

##### providers
providerには、処理を行わない、表示だけを管理するproviderを配置します。
例としては、値をdomeinのserviceからとってくるだけのものや、applicationのproviderから取得するものなどです。原則として、データの加工は行いません。
複数のソースをwatchして、UIに最適な形に整えるだけの読み取り専用プロバイダになります。

##### state
例えば、ウィジェットに紐づく状態が複数ある場合はこのstateでデータクラスを定義して、それを単一のproviderで管理するようにします。
このアプリの例でいうと、単位カードは複数のproviderに紐づいています。
```dart
@riverpod
CourseCardState courseCardStateProvider(
  Ref ref, 
  CourseModel course,
  ThemeData theme
) {
    final isCreditsCompleted = ref.watch(
      isCreditCompletedProvider(course),
    );

    final egService = ref.watch(exclusiveGroupServiceProvider);
    final egs = ref.watch(exclusiveGroupsProvider);
    final eg = egService.findGroupByCourse(egs, course);

    final activeColor = isCreditsCompleted
        ? theme.colorScheme.primary
        : theme.dividerColor.withAlpha(40);

    final clService = ref.watch(creditLimitServiceProvider);
    final clgs = ref.watch(creditLimitGroupProvider);
    final clrs = clService.findRuleByCourse(
      limitGroups: clgs,
      course: course
    );

    return CourseCardState(
      isCreditsCompleted: isCreditsCompleted, 
      eg: eg, 
      activeColor: activeColor, 
      clrs: clrs
    );
}
```

それを一元化したデータクラスを定義する場所がこのディレクトリです。

### widgets
ここには機能に紐づかない共通部品コンポーネントを定義します。
