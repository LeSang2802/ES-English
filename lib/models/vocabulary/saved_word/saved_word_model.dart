class SavedWordModel {
  final String id;
  final String en;
  final String vi;
  final String type;
  final bool isSaved;

  SavedWordModel({
    required this.id,
    required this.en,
    required this.vi,
    required this.type,
    this.isSaved = true,
  });

  SavedWordModel copyWith({bool? isSaved}) {
    return SavedWordModel(
      id: id,
      en: en,
      vi: vi,
      type: type,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
