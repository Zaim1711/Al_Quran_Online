// prayer_time_service.dart (Kode yang sudah dikoreksi dan final)

import 'package:adhan_dart/adhan_dart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ... (PrayerTimesModel class tetap sama) ...
class PrayerTimesModel {
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String nextPrayerName;
  final DateTime nextPrayerTime;

  PrayerTimesModel({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.nextPrayerName,
    required this.nextPrayerTime,
  });
}
// ...

class PrayerTimeService extends GetxService {
  Rxn<PrayerTimesModel> currentPrayerTimes = Rxn<PrayerTimesModel>();

  final double defaultLatitude = -7.2575; // Surabaya
  final double defaultLongitude = 112.7521; // Surabaya
  final String defaultTimeZoneName = 'Asia/Jakarta';

  @override
  void onInit() {
    super.onInit();
    tz.initializeTimeZones();
    // Panggil perhitungan saat inisialisasi
    calculatePrayerTimes();
  }

  void calculatePrayerTimes({double? lat, double? lng, String? tzName}) {
    final location = tz.getLocation(tzName ?? defaultTimeZoneName);
    // Waktu saat ini di zona waktu yang ditentukan (Asia/Jakarta)
    final now = tz.TZDateTime.from(DateTime.now(), location);

    final coordinates = Coordinates(
      lat ?? defaultLatitude,
      lng ?? defaultLongitude,
    );

    CalculationParameters params =
        CalculationMethodParameters.moonsightingCommittee();

    // Konfigurasi Madhab (Asr)
    params.madhab = Madhab.shafi;

    // Hitung Waktu Sholat untuk Hari Ini
    PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: now,
      calculationParameters: params,
      precision: true,
    );

    // Helper untuk konversi ke TZDateTime
    DateTime _getTZDateTimeHelper(DateTime? dt) {
      // Menggunakan now sebagai fallback jika waktu tidak tersedia
      return tz.TZDateTime.from(dt ?? now, location);
    }

    // Ambil dan konversi waktu sholat
    final fajrTime = _getTZDateTimeHelper(prayerTimes.fajr);
    final dhuhrTime = _getTZDateTimeHelper(prayerTimes.dhuhr);
    final asrTime = _getTZDateTimeHelper(prayerTimes.asr);
    final maghribTime = _getTZDateTimeHelper(prayerTimes.maghrib);
    final ishaTime = _getTZDateTimeHelper(prayerTimes.isha);

    // Convenience Utilities
    final nextPrayerEnum = prayerTimes.nextPrayer();

    final nextPrayerName = nextPrayerEnum.name;

    final nextPrayerTime = _getTZDateTimeHelper(
      prayerTimes.timeForPrayer(nextPrayerEnum),
    );

    // Update State
    currentPrayerTimes.value = PrayerTimesModel(
      fajr: fajrTime,
      dhuhr: dhuhrTime,
      asr: asrTime,
      maghrib: maghribTime,
      isha: ishaTime,
      nextPrayerName: nextPrayerName,
      nextPrayerTime: nextPrayerTime,
    );

    print(
      '✅ Jadwal Sholat berhasil dihitung untuk ${DateFormat('yyyy-MM-dd').format(now)}. Berikutnya: $nextPrayerName pada ${DateFormat('h:mm a').format(nextPrayerTime)}',
    );
  }
}
