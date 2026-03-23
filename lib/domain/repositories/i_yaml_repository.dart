abstract class IYamlRepository {
  Future<Map<String, dynamic>> loadFromAssets(String path);
}
