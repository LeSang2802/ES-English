import 'package:es_english/cores/flavors/base_application.dart';
import 'package:es_english/cores/translates/app_translations.dart';
import 'package:es_english/routes/app_pages.dart';
import 'package:es_english/routes/route_name.dart';

class Application extends BaseApplication<AppTranslations> {
   Application({super.key})
      : super(
    listPages: AppPages.appPages,
    initialRoute: RouteNames.login,
    translations: AppTranslations(),
  );
}
