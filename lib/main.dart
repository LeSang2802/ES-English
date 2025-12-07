// import 'package:flutter/material.dart';
// import 'package:es_english/application.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get_storage/get_storage.dart';
// import 'cores/study_time/study_time_service.dart';
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//   await Get.putAsync(() async {
//   final service = StudyTimeService();
//   await service.restoreSession();
//   await service.retryFailedSessions();
//   return service;
//   });
//   runApp(Application());
// }

import 'package:flutter/material.dart';
import 'package:es_english/application.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'cores/study_time/study_time_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Khởi tạo StudyTimeService
  await Get.putAsync(() async {
    final service = StudyTimeService();
    await service.restoreSession();
    await service.retryFailedSessions();
    return service;
  });

  runApp(MyAppWrapper());
}

// Wrapper để handle lifecycle
class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final studyTimeService = StudyTimeService.to;

    switch (state) {
      case AppLifecycleState.resumed:
        print('📱 App resumed');
        studyTimeService.startSession();
        studyTimeService.retryFailedSessions();
        break;

      case AppLifecycleState.paused:
        print('📱 App paused');
        studyTimeService.endSession();
        break;

      case AppLifecycleState.inactive:
        print('📱 App inactive');
        studyTimeService.endSession();
        break;

      case AppLifecycleState.detached:
        print('📱 App detached');
        studyTimeService.endSession();
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Application();
  }
}