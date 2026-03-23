enum CurriculumType {
  t2023("2023年度入学者, 情報通信工学科", "assets/data/curriculum/T-2023.yaml");

  const CurriculumType(
    this.label,
    this.path
  );

  final String label;
  final String path;
}
