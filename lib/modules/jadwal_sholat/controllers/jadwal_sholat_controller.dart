import 'package:al_quran/data/model/prayer_time.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalSholatController extends GetxController {
  final PrayerTimeService prayerTimeService = Get.put(PrayerTimeService());

  RxBool isDark = false.obs;

  Rx<Position?> currentLocation = Rxn<Position?>(null);

  RxString locationName = 'Memuat...'.obs;

  static const String _latKey = 'userLangitude';
  static const String _lngKey = 'userLongitude';
  static const String _nameKey = 'locationName';

  @override
  void onInit() {
    super.onInit();

    loadAndCheckLocation();
    // getLocation();
  }

  Future<void> _saveLocationData(double lat, double lng, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, lat);
    await prefs.setDouble(_lngKey, lng);
    await prefs.setString(_nameKey, name);
    print('💾 Lokasi dan koordinat berhasil disimpan ke SharedPreferences.');
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Lokasi Dinonaktifkan',
        'Layanan lokasi dimatikan. Silakan aktifkan layanan lokasi.',
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Izin Ditolak",
          "Izin lokasi ditolak.Jadwal sholat tidak dapat dimuat.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Izin Ditolak Permanen",
        "Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  Future<void> getLocation() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      // Atur ke lokasi default jika izin gagal
      currentLocation.value = null;
      locationName.value = 'Lokasi Default';
      // ...
      return;
    }

    try {
      // 1. Ambil posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      currentLocation.value = position;

      // 2. Lakukan Reverse Geocoding untuk mendapatkan nama lokasi
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        // Jika Anda menggunakan bahasa Indonesia/local, tambahkan localeIdentifier
        // localeIdentifier: "id_ID"
      );

      String locationText = 'Lokasi Ditemukan'; // Default sementara

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Mengamankan semua properti dari NULL menggunakan operator '??'
        // Mencari Kota/Wilayah Administratif
        String city = place.subAdministrativeArea ?? place.locality ?? '';
        String state = place.administrativeArea ?? '';
        String country = place.country ?? '';

        if (city.isNotEmpty && state.isNotEmpty) {
          locationText = "$city, $state";
        } else if (city.isNotEmpty) {
          locationText = "$city, $country";
        } else if (state.isNotEmpty) {
          locationText = "$state, $country";
        } else {
          // Fallback jika data wilayah tidak ada
          locationText =
              place.name ?? place.street ?? 'Lokasi Detail Tidak Tersedia';
        }
      }

      // 3. Update jadwal sholat dengan koordinat baru dan nama lokasi
      locationName.value = locationText;
      updatePrayerTimes(position.latitude, position.longitude);

      await _saveLocationData(
        position.latitude,
        position.longitude,
        locationText,
      );
    } catch (e) {
      // Blok try-catch menangkap error geolocator atau geocoding
      print("Error mengambil lokasi/geocoding: $e");
      currentLocation.value = null;
      locationName.value = 'Gagal Memuat Lokasi'; // Tampilkan pesan error
    }
  }

  Future<void> loadAndCheckLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    final name = prefs.getString(_nameKey);

    // Cek apakah data tersimpan di SharedPreferences
    if (lat != null && lng != null && name != null) {
      print('✅ Lokasi dimuat dari SharedPreferences.');

      // Gunakan data tersimpan
      locationName.value = name;
      updatePrayerTimes(lat, lng);

      // Catatan: currentLocation.value tidak diisi karena tidak ada objek Position
      // yang disimpan, hanya koordinatnya. Ini tidak masalah.
    } else {
      print('❌ Lokasi tidak ditemukan di SharedPreferences. Memanggil GPS...');
      // Jika tidak ada data tersimpan, panggil method GPS (seperti sebelumnya)
      getLocation();
    }
  }

  // Metode untuk memanggil update jadwal sholat (Perlu Anda definisikan di PrayerTimeService)
  void updatePrayerTimes(double lat, double lon) {
    // Panggil service untuk menghitung ulang jadwal sholat
    prayerTimeService.calculatePrayerTimes(lat: lat, lng: lon);
  }
}
