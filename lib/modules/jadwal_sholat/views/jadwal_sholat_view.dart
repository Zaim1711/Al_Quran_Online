import 'package:al_quran/constants/color.dart';
import 'package:al_quran/modules/jadwal_sholat/controllers/jadwal_sholat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// tz imports sudah ada di controller, tapi kita pertahankan untuk safety
import 'package:timezone/data/latest.dart' as tz;

class JadwalSholatView extends StatefulWidget {
  @override
  State<JadwalSholatView> createState() => _JadwalSholatViewState();
}

class _JadwalSholatViewState extends State<JadwalSholatView> {
  final JadwalSholatController controller = Get.find<JadwalSholatController>();

  // Catatan: Inisialisasi lokasi di sini tidak diperlukan
  // karena sudah dihandle di PrayerTimeService.

  @override
  void initState() {
    super.initState();
    // Panggil inisialisasi timezone, pastikan ini terjadi sekali.
    // Jika Anda sudah melakukannya di main.dart, baris ini bisa dihapus.
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? appGreenDark
          : appWhite, // Atur background Scaffold
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        foregroundColor: Get.isDarkMode ? appWhite : appGreen,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            'Jadwal Sholat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: appWhite,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Tambahkan logika untuk pengaturan atau info lokasi
            },
            icon: const Icon(Icons.settings_outlined, size: 28),
            color: appWhite,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        children: [
          // 2. Card Jadwal Sholat Hari Ini (Current Prayer Time Card)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCurrentPrayerTimeCard(context),
          ),

          const SizedBox(height: 30),

          // 3. Header Daftar Waktu Sholat Harian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Waktu Sholat Hari Ini (${DateFormat('dd/MM/yyyy').format(DateTime.now())})",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? appWhite : appGreen,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 4. Daftar Waktu Sholat Harian
          _buildDailyPrayerList(),
        ],
      ),
    );
  }

  // Card Utama (Waktu Sholat Berikutnya)
  Widget _buildCurrentPrayerTimeCard(BuildContext context) {
    final service = controller.prayerTimeService;

    return Obx(() {
      final data = service.currentPrayerTimes.value;
      if (data == null) {
        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator(color: appGreenDark)),
        );
      }

      String formatTime(DateTime dt) => DateFormat('HH:mm a').format(dt);

      final nextPrayerTime = data.nextPrayerTime;
      final difference = nextPrayerTime.difference(DateTime.now());

      // Mengubah format countdown ke jam dan menit saja
      final String countdownText = difference.isNegative
          ? "Waktunya Sholat!"
          : "Waktu Tersisa: ${difference.inHours} jam ${difference.inMinutes.remainder(60)} menit";

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: appWhite.withOpacity(0.4), width: 1.5),
          gradient: const LinearGradient(
            colors: [appGreenLight, appGreenDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: appGreenDark.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gambar Dekorasi
            Positioned(
              top: 18,
              right: -10,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  "assets/images/Alquran_images.png",
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Konten Teks Jadwal Sholat
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LOKASI
                GestureDetector(
                  onTap: () {
                    controller.getLocation();
                  },
                  // Row adalah child dari GestureDetector
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: appWhite, size: 20),
                      const SizedBox(width: 8),
                      Obx(
                        () => Text(
                          controller.locationName.value,
                          style: const TextStyle(color: appWhite, fontSize: 16),
                        ),
                      ),
                      const Icon(Icons.edit, color: appWhite, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. NAMA SHOLAT BERIKUTNYA
                Text(
                  data.nextPrayerName.toUpperCase(),
                  style: const TextStyle(
                    color: appWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                // 3. WAKTU SHOLAT BERIKUTNYA
                Text(
                  formatTime(data.nextPrayerTime),
                  style: const TextStyle(
                    color: appWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),

                // 4. HITUNGAN MUNDUR
                Text(
                  countdownText,
                  style: const TextStyle(color: appWhite, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // Daftar Sholat Harian (Di dalam satu Card besar)
  // Di JadwalSholatView.dart

  Widget _buildDailyPrayerList() {
    final service = controller.prayerTimeService;

    return Obx(() {
      final data = service.currentPrayerTimes.value;
      if (data == null) return const SizedBox();

      // V MODIFIKASI 1: TAMBAH DESKRIPSI KE STRUKTUR DATA V
      final List<Map<String, dynamic>> prayerTimes = [
        {
          'name': 'Fajr',
          'time': data.fajr,
          'icon': Icons.wb_sunny_outlined,
          'description': 'Sholat di waktu fajar sebelum matahari terbit.',
        },
        {
          'name': 'Dhuhr',
          'time': data.dhuhr,
          'icon': Icons.wb_sunny_rounded,
          'description':
              'Sholat di waktu tengah hari setelah matahari tergelincir.',
        },
        {
          'name': 'Asr',
          'time': data.asr,
          'icon': Icons.cloud_queue,
          'description':
              'Sholat di waktu sore hari menjelang matahari terbenam.',
        },
        {
          'name': 'Maghrib',
          'time': data.maghrib,
          'icon': Icons.nights_stay_outlined,
          'description':
              'Sholat di waktu senja setelah matahari benar-benar terbenam.',
        },
        {
          'name': 'Isha',
          'time': data.isha,
          'icon': Icons.star_border,
          'description':
              'Sholat di waktu malam hingga menjelang fajar berikutnya.',
        },
      ];
      // ^ MODIFIKASI 1 SELESAI ^

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prayerTimes.length,
            itemBuilder: (context, index) {
              final time = prayerTimes[index];
              bool isCurrent =
                  (time['name'] as String).toLowerCase() ==
                  data.nextPrayerName.toLowerCase();

              // Menentukan warna aksen
              final Color highlightColor = Get.isDarkMode
                  ? appGreenLight
                  : appGreenDark;
              final Color defaultTextColor = Get.isDarkMode
                  ? appWhite
                  : appGreen;
              final Color defaultIconColor = Get.isDarkMode
                  ? appWhite.withOpacity(0.7)
                  : Colors.grey;
              final Color subtitleColor = Get.isDarkMode
                  ? appWhite.withOpacity(0.6)
                  : Colors.grey.shade600;

              return Container(
                decoration: BoxDecoration(
                  color: isCurrent
                      ? highlightColor.withOpacity(0.1)
                      : appWhite.withOpacity(0.0),

                  border: isCurrent
                      ? Border(left: BorderSide(color: highlightColor))
                      : null,

                  borderRadius: index == 0
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )
                      : index == prayerTimes.length - 1
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )
                      : BorderRadius.zero,
                ),
                child: ListTile(
                  leading: Icon(
                    time['icon'] as IconData,
                    color: isCurrent ? highlightColor : defaultIconColor,
                  ),

                  title: Text(
                    time['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? highlightColor : defaultTextColor,
                    ),
                  ),

                  // V MODIFIKASI 2: TAMBAH SUBTITLE (DESKRIPSI) V
                  subtitle: Text(
                    time['description'] as String,
                    style: TextStyle(
                      color: isCurrent ? highlightColor : subtitleColor,
                      fontSize: 12,
                      fontWeight: isCurrent
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),

                  // ^ MODIFIKASI 2 SELESAI ^
                  trailing: SizedBox(
                    width: 90,
                    child: Text(
                      DateFormat('HH:mm a').format(time['time'] as DateTime),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrent ? highlightColor : defaultTextColor,
                      ),
                    ),
                  ),

                  onTap: () {
                    // Aksi saat item waktu sholat diklik
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
