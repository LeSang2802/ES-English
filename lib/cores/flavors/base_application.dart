import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../translates/language_controller.dart';


abstract class BaseApplication<T extends Translations> extends StatelessWidget {
  List<GetPage> listPages;
  String initialRoute;
  T translations;

  BaseApplication({
    super.key,
    required this.listPages,
    required this.initialRoute,
    required this.translations,
  });

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController(), permanent: true);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (_, __) => Obx(() {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: translations,
          locale: langController.currentLocale.value,
          fallbackLocale: const Locale('en'),
          initialRoute: initialRoute,
          getPages: listPages,
        );
      }),
    );
  }
}
