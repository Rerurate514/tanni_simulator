enum CategoryType {
  //専門
  professional,
  //教養
  general
}

extension CategoryTypeEx on CategoryType {
  String get nameJP {
    return switch(this) {
      CategoryType.professional => '専門教育科目',
      CategoryType.general => '教養教育科目',
    };
  }
}
