import 'package:flutter/material.dart';
import 'package:es_english/application.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(Application());
}