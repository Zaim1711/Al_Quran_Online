import 'package:al_quran/constants/color.dart';
import 'package:al_quran/modules/jadwal_sholat/controllers/jadwal_sholat_controller.dart';
import 'package:al_quran/routes/app_pages.dart';
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: appBlueDark,
          // gradient: LinearGradient(
          //   colors: [appBlueLight, appBlueDark],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCurrentPrayerTimeCard(),
              ),
              const SizedBox(height: 20),
              _buildMenuSection(),
              const SizedBox(height: 30),
              _buildBottomPanel(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= APP BAR =================
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Assalamu'alaikum",
            style: TextStyle(
              color: appWhite,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: appWhite),
          ),
        ],
      ),
    );
  }

  // ================= CARD JADWAL SHOLAT =================
  Widget _buildCurrentPrayerTimeCard() {
    final service = controller.prayerTimeService;

    return Obx(() {
      final data = service.currentPrayerTimes.value;
      if (data == null) {
        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator(color: appWhite)),
        );
      }

      final difference = data.nextPrayerTime.difference(DateTime.now());

      final countdownText = difference.isNegative
          ? "Waktunya Sholat"
          : "${difference.inHours} Jam ${difference.inMinutes.remainder(60)} Menit";

      return Container(
        padding: const EdgeInsets.all(20),
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [appBlueLight, appBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 10,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset("assets/images/Pray.png", width: 140),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: controller.getLocation,
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: appWhite, size: 18),
                      const SizedBox(width: 6),
                      Obx(
                        () => Text(
                          controller.locationName.value,
                          style: const TextStyle(color: appWhite, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  data.nextPrayerName.toUpperCase(),
                  style: const TextStyle(
                    color: appWhite,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat('hh:mm a').format(data.nextPrayerTime),
                  style: const TextStyle(color: appWhite, fontSize: 18),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: appWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    countdownText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appBlueDark,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ================= MENU ICON =================
  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MenuItem(
            title: "Al'Quran",
            icon: Icons.menu_book,
            onTap: () {
              Get.toNamed(Routes.SURAH);
            },
          ),
          _MenuItem(
            title: "Murottal",
            icon: Icons.headphones,
            onTap: () {
              Get.toNamed(Routes.SURAH);
            },
          ),
          _MenuItem(title: "Tafsir", icon: Icons.book),
        ],
      ),
    );
  }

  // ================= PANEL BAWAH =================
  Widget _buildBottomPanel() {
    final service = controller.prayerTimeService;

    return Obx(() {
      final data = service.currentPrayerTimes.value;
      if (data == null) return const SizedBox();

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
          'icon': Icons.wb_sunny_outlined,
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  appYellowLight, // kuning muda
                  appWhite, // kuning tua
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prayerTimes.length,
              itemBuilder: (context, index) {
                final time = prayerTimes[index];
                final bool isCurrent =
                    (time['name'] as String).toLowerCase() ==
                    data.nextPrayerName.toLowerCase();

                final Color defaultTextColor = appBlueDark;
                final Color subtitleColor = appBlueDark.withOpacity(0.6);

                return Container(
                  decoration: isCurrent
                      ? BoxDecoration(
                          color: appWhite.withOpacity(0.6),
                          // border: const Border(
                          //   left: BorderSide(color: appBlueDark, width: 0),
                          // ),
                        )
                      : const BoxDecoration(), // WAJIB supaya tidak null
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    minLeadingWidth: 24,
                    horizontalTitleGap: 8,
                    leading: Icon(
                      time['icon'] as IconData,
                      size: 18,
                      color: appBlueDark,
                    ),
                    title: Text(
                      time['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appBlueDark,
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                    subtitle: Text(
                      time['description'] as String,
                      style: TextStyle(
                        color: appBlueDark.withOpacity(0.6),
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                    trailing: Text(
                      DateFormat('HH:mm a').format(time['time'] as DateTime),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: appBlueDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

// ================= MENU ITEM WIDGET =================
class _MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.title,
    required this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [appBlueLight, appBlueDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: appWhite, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: appWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Daftar Sholat Harian (Di dalam satu Card besar)
  // Di JadwalSholatView.dart
}
