import 'package:es_english/cores/translates/en.dart';
import 'package:es_english/cores/translates/vi.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'vi': { ...(Vietnamese.message) },
      'en': { ...(English.message) }
    };
  }
}
