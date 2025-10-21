import 'package:es_english/cores/constants/api_paths.dart';
import 'package:es_english/cores/constants/base_api_client.dart';
import 'package:es_english/models/level/level_response_model.dart';

class LevelRepository {
  final BaseApiClient _api = BaseApiClient();

  Future<List<LevelResponseModel>> getLevels() async {
    final res = await _api.get(ApiPaths.level);
    final List data = res.data;
    return data.map((e) => LevelResponseModel.fromJson(e)).toList();
  }
}
