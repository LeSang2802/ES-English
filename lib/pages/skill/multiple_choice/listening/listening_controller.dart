import 'package:es_english/pages/skill/multiple_choice/shared/mcq_controller.dart';
import '../../../../models/skill/multiple_choice/mcq_response_model.dart';
import 'listening_repository.dart';

class ListeningController extends McqController {
  final ListeningRepository repo = ListeningRepository();

  @override
  dynamic get contentRepo => repo;

  @override
  String get contentType => "LISTENING_AUDIO";

  @override
  Future<McqResponseModel> fetchDetail(String contentId) =>
      repo.getListeningDetail(contentId);

  @override
  Future<List<String>> fetchAllContentIds(String topicId) =>
      repo.getAllContentIdsByTopic(topicId, type: contentType);
}
