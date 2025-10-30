import 'package:es_english/pages/skill/multiple_choice/shared/mcq_controller.dart';
import '../../../../models/skill/multiple_choice/mcq_response_model.dart';
import 'reading_repository.dart';

class ReadingController extends McqController {
  final ReadingRepository repo = ReadingRepository();

  @override
  dynamic get contentRepo => repo;

  @override
  String get contentType => "READING_PASSAGE";

  @override
    Future<McqResponseModel> fetchDetail(String contentId) =>
      repo.getReadingDetail(contentId);

  @override
  Future<List<String>> fetchAllContentIds(String topicId) =>
      repo.getAllContentIdsByTopic(topicId, type: contentType);
}
