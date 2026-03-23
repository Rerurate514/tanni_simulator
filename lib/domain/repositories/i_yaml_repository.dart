import 'package:tanni_simulator/infrastructure/models/curriculum.dart';

abstract class IYamlRepository {
  Future<CurriculumModel> loadFromAssets(String path);
}
