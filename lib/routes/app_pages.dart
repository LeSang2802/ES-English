import 'package:es_english/pages/account/account_binding.dart';
import 'package:es_english/pages/account/account_page.dart';
import 'package:es_english/pages/home/home_binding.dart';
import 'package:es_english/pages/home/home_page.dart';
import 'package:es_english/pages/login/login_binding.dart';
import 'package:es_english/pages/login/login_page.dart';
import 'package:es_english/pages/progress/progress_binding.dart';
import 'package:es_english/pages/progress/progress_page.dart';
import 'package:es_english/pages/reading/reading_binding.dart';
import 'package:es_english/pages/reading/reading_page.dart';
import 'package:es_english/pages/register/register_binding.dart';
import 'package:es_english/pages/register/register_page.dart';
import 'package:es_english/pages/skill/skill_binding.dart';
import 'package:es_english/pages/skill/skill_page.dart';
import 'package:es_english/pages/vocabulary/flash_card/flash_card_page.dart';
import 'package:es_english/pages/vocabulary/saved_word/saved_word_binding.dart';
import 'package:es_english/routes/route_name.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../pages/chatbot/chat_page.dart';
import '../pages/level/level_binding.dart';
import '../pages/level/level_page.dart';
import '../pages/vocabulary/flash_card/flash_card_binding.dart';
import '../pages/vocabulary/saved_word/saved_word_page.dart';
import '../pages/vocabulary/vocabulary_binding.dart';
import '../pages/vocabulary/vocabulary_page.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> appPages = [
    GetPage(
      name: RouteNames.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteNames.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: RouteNames.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteNames.skill,
      page: () => const SkillPage(),
      binding: SkillBinding(),
    ),
    GetPage(
      name: RouteNames.progress,
      page: () => const ProgressPage(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: RouteNames.account,
      page: () => const AccountPage(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: RouteNames.vocabulary,
      page: () => const VocabularyPage(),
      binding: VocabularyBinding(),
    ),
    GetPage(
      name: RouteNames.flashCard,
      page: () => const FlashCardPage(),
      binding: FlashCardBinding(),
    ),
    GetPage(
      name: RouteNames.savedWord,
      page: () => const SavedWordPage(),
      binding: SavedWordBinding(),
    ),
    GetPage(
      name: RouteNames.reading,
      page: () => const ReadingPage(),
      binding: ReadingBinding(),
    ),
    GetPage(
      name: RouteNames.level,
      page: () => const LevelPage(),
      binding: LevelBinding(),
    ),
    GetPage(
      name: RouteNames.chatbot,
      page: () => ChatPage(),
    ),
  ];
}