import 'package:al_quran/modules/jadwal_sholat/bindings/jadwal_sholat_binding.dart';
import 'package:al_quran/modules/jadwal_sholat/views/jadwal_sholat_view.dart';
import 'package:get/get.dart';

import '../modules/detail_surah/controllers/detail_surah_controller.dart';
import '../modules/detail_surah/views/detail_surah_view.dart';
import '../modules/introduction/bindings/introduction_binding.dart';
import '../modules/introduction/views/introduction_view.dart';
import '../modules/search_surah/bindings/search_surah_binding.dart';
import '../modules/search_surah/views/search_surah_view.dart';
import '../modules/surah/bindings/surah_binding.dart';
import '../modules/surah/views/surah_view.dart';
import '../modules/tafsir/bindings/tafsir_binding.dart';
import '../modules/tafsir/views/tafsir_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SURAH;

  static final routes = [
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => const IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.SURAH,
      page: () => SurahView(),
      binding: SurahBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SURAH,
      page: () => DetailSurahView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DetailSurahController>(() => DetailSurahController());
      }),
    ),
    GetPage(
      name: _Paths.TAFSIR,
      page: () => TafsirView(),
      binding: TafsirBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_SURAH,
      page: () => SearchSurahView(),
      binding: SearchSurahBinding(),
    ),
    GetPage(
      name: _Paths.JadwalSholatView,
      page: () => JadwalSholatView(),
      binding: JadwalSholatBinding(),
    ),
  ];
}
