enum CurriculumType {
  t2023('2023年度入学者, 情報通信工学科', 'assets/data/curriculum/T-2023.yaml'),
  t2024('2024年度入学者, 情報通信工学科', 'assets/data/curriculum/T-2024.yaml'),
  t2025('2025年度入学者, 情報通信工学課程', 'assets/data/curriculum/T-2025.yaml'),
  t2026('2026年度入学者, 情報通信工学課程', 'assets/data/curriculum/T-2026.yaml');

  const CurriculumType(
    this.label,
    this.path
  );

  final String label;
  final String path;
}
