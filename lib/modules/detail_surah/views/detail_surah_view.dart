import 'package:al_quran/constants/color.dart';
import 'package:al_quran/data/model/detailSurah.dart'; // Sesuaikan path sesuai struktur proyek
import 'package:al_quran/modules/surah/controllers/surah_controller.dart';
import 'package:al_quran/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart'; // Sesuaikan path sesuai struktur proyek

class DetailSurahView extends GetView<DetailSurahController> {
  final SurahController surahC = Get.find<SurahController>();
  Map<String, dynamic>? bookmark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (controller.surahDetails.value == null) {
            return const Text('');
          }
          return Text(
            "SURAH ${controller.surahDetails.value!.namaLatin!.toString().toUpperCase()}",
            style: const TextStyle(color: Colors.white),
          );
        }),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: appWhite),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (controller.surahDetails.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (Get.arguments?["bookmark"] != null) {
          bookmark = Get.arguments!["bookmark"] as Map<String, dynamic>?;
          print("INDEX AYAT : ${bookmark!["index_ayat"] + 2}");
          controller.scrollC.scrollToIndex(
            bookmark!["index_ayat"] + 2,
            preferPosition: AutoScrollPosition.begin,
          );
        }

        DetailSurah surah = controller.surahDetails.value!;

        List<Widget> allAyat = List.generate(surah.ayat!.length, (index) {
          Ayat ayat = surah.ayat![index];
          int ayatNumber = ayat.nomorAyat!;

          return AutoScrollTag(
            key: ValueKey(index + 2),
            index: index + 2,
            controller: controller.scrollC,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appGreenLight.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                Get.isDarkMode
                                    ? "assets/images/octagonwhite_list.png"
                                    : "assets/images/octagon_list.png",
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          child: Center(child: Text("$ayatNumber")),
                        ),
                        GetBuilder<DetailSurahController>(
                          builder: (c) => Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text(
                                          "BOOKMARK",
                                          style: TextStyle(
                                            color: Get.isDarkMode
                                                ? appWhite
                                                : appGreen,
                                          ),
                                        ),
                                        backgroundColor: Get.isDarkMode
                                            ? appGreen
                                            : appWhite,
                                        content: Text("Pilih jenis bookmark"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(
                                                dialogContext,
                                              ).pop(); // Tutup dialog

                                              var result = await c.addBookmark(
                                                true,
                                                surah,
                                                ayat,
                                                index,
                                              );

                                              surahC.update();

                                              // Tampilkan snackbar
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    result["message"],
                                                    style: TextStyle(
                                                      color: appWhite,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      result["success"]
                                                      ? appOrange
                                                      : const Color.fromARGB(
                                                          255,
                                                          255,
                                                          255,
                                                          255,
                                                        ),
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Last Read",
                                              style: TextStyle(
                                                color: Get.isDarkMode
                                                    ? appWhite
                                                    : appGreen,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(
                                                dialogContext,
                                              ).pop(); // Tutup dialog

                                              var result = await c.addBookmark(
                                                false,
                                                surah,
                                                ayat,
                                                index,
                                              );

                                              // Tampilkan snackbar
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    result["message"],
                                                    style: TextStyle(
                                                      color: appWhite,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      result["success"]
                                                      ? appGreen
                                                      : appGreenLight,
                                                  duration: Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Bookmark",
                                              style: TextStyle(
                                                color: Get.isDarkMode
                                                    ? appWhite
                                                    : appGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.bookmark_add_outlined),
                              ),
                              (ayat.kondisiAudio == "stop")
                                  ? IconButton(
                                      onPressed: () {
                                        c.playAudio(ayat);
                                      },
                                      icon: const Icon(Icons.play_arrow),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (ayat.kondisiAudio == "playing")
                                            ? IconButton(
                                                onPressed: () {
                                                  c.pauseAudio(ayat);
                                                },
                                                icon: const Icon(Icons.pause),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  c.resumeAudio(ayat);
                                                },
                                                icon: const Icon(
                                                  Icons.play_arrow,
                                                ),
                                              ),
                                        IconButton(
                                          onPressed: () {
                                            c.stopAudio(ayat);
                                          },
                                          icon: const Icon(Icons.stop),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  ayat.teksArab!,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(ayat.teksLatin!, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 25),
                Text(
                  ayat.teksIndonesia!,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        });

        return Scrollbar(
          child: ListView(
            controller: controller.scrollC,
            padding: const EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: const ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.TAFSIR,
                      arguments: {'surahNumber': surah.nomor},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [appGreenLight, appGreenDark],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${surah.namaLatin?.toUpperCase() ?? 'Error...'} - ${surah.nama?.toUpperCase() ?? 'Error..'}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: appWhite,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${surah.arti ?? 'Error..'} | ${surah.jumlahAyat ?? 'Error..'} Ayat | ${surah.tempatTurun}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: appWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                key: const ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: const SizedBox(height: 20),
              ),
              ...allAyat,
            ],
          ),
        );
      }),
    );
  }
}
