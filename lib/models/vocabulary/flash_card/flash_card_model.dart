class FlashCardModel {
  String? id;
  String? en;
  String? vi;
  String? type;
  String? imageUrl;
  String audioUrl;
  bool isSaved;

  FlashCardModel({
    this.id,
    this.en,
    this.vi,
    this.type,
    this.imageUrl,
    required this.audioUrl,
    this.isSaved = false,
  });
}

// class FlashcardModel {
//   final String id;
//   final String word;
//   final String? phonetic;
//   final String? partOfSpeech;
//   final String? meaningVi;
//   final String? exampleEn;
//   final String? exampleVi;
//   final String? audioUrl;
//   final String? imageUrl;
//
//   FlashcardModel({
//     required this.id,
//     required this.word,
//     this.phonetic,
//     this.partOfSpeech,
//     this.meaningVi,
//     this.exampleEn,
//     this.exampleVi,
//     this.audioUrl,
//     this.imageUrl,
//   });
//
//   factory FlashcardModel.fromJson(Map<String, dynamic> json) {
//     return FlashcardModel(
//       id: json['_id'] ?? '',
//       word: json['word'] ?? '',
//       phonetic: json['phonetic'],
//       partOfSpeech: json['part_of_speech'],
//       meaningVi: json['meaning_vi'],
//       exampleEn: json['example_en'],
//       exampleVi: json['example_vi'],
//       audioUrl: json['audio_url'],
//       imageUrl: json['image_url'],
//     );
//   }
// }

