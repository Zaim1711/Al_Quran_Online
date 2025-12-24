import 'package:al_quran/constants/color.dart';
import 'package:al_quran/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  box.read("theme") != null;
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appLight,
      darkTheme: appDark,
      themeMode: ThemeMode.dark,
      title: "Application",
      initialRoute: Routes.INTRODUCTION,
      getPages: AppPages.routes,
    ),
  );
}
