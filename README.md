# Geo - Aplikasi Peta Catatan Lokasi

Geo adalah aplikasi Flutter untuk menandai dan mencatat lokasi penting di peta interaktif. Anda dapat menambahkan catatan di lokasi tertentu, melihat alamat otomatis, dan menyimpannya secara lokal di perangkat.

## Fitur Utama

- 🗺️ **Peta Interaktif**: Menampilkan peta menggunakan Flutter Map dengan OpenStreetMap
- 📍 **Lokasi Saat Ini**: Tombol untuk menemukan dan menampilkan lokasi GPS Anda saat ini
- 📌 **Tambah Catatan**: Long press pada peta untuk menambahkan catatan di lokasi tersebut
- 🏷️ **Klasifikasi Lokasi**: Pilih tipe lokasi (toko, rumah, kantor, dll)
- 🔍 **Reverse Geocoding**: Otomatis mengkonversi koordinat menjadi alamat jalan
- 💾 **Simpan Lokal**: Semua catatan disimpan di SharedPreferences perangkat
- 📋 **Daftar Catatan**: Lihat semua catatan yang telah disimpan dengan detail lokasi

## Persyaratan Sistem

- Flutter SDK 3.9.2 atau lebih tinggi
- Dart SDK 3.9.2 atau lebih tinggi
- Android SDK 21+ (atau sesuai dengan target SDK di proyek)
- iOS 11.0+ (untuk dukungan iOS)

## Dependensi

- `flutter_map: ^6.0.0` - Menampilkan peta interaktif
- `latlong2: ^0.9.0` - Tipe data untuk koordinat geografis
- `geolocator: ^9.0.2` - Mengakses GPS dan lokasi perangkat
- `geocoding: ^2.1.0` - Reverse geocoding (koordinat ke alamat)
- `shared_preferences: ^2.2.0` - Penyimpanan data lokal
- `cupertino_icons: ^1.0.8` - Ikon iOS
- `flutter_lints: ^5.0.0` - Linting tools

## Instalasi dan Setup

### 1. Clone Repository

```bash
git clone https://github.com/zenverovenopasa/geo.git
cd geo
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi Android

Izin lokasi sudah ditambahkan di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Saat aplikasi pertama kali dijalankan, sistem akan meminta izin akses lokasi.

### 4. Konfigurasi iOS (Opsional)

Untuk iOS, tambahkan ke `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi membutuhkan akses lokasi untuk menampilkan lokasi Anda di peta.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Aplikasi membutuhkan akses lokasi untuk menampilkan lokasi Anda di peta.</string>
```

## Cara Menggunakan

### Menjalankan Aplikasi

```bash
flutter run
```

Untuk menjalankan di emulator atau device spesifik:

```bash
flutter run -d <device-id>
```

### Fitur Aplikasi

1. **Lihat Peta**: Aplikasi menampilkan peta OpenStreetMap saat dibuka
2. **Temukan Lokasi Saya**: Tap tombol lokasi (biasanya ikon kompas/pin) untuk menavigasi ke lokasi GPS Anda
3. **Tambah Catatan**:
   - Long press di lokasi manapun di peta
   - Dialog akan muncul untuk memilih tipe lokasi dan memasukkan catatan
   - Alamat jalan akan ditampilkan otomatis (reverse geocoding)
   - Tap "Simpan" untuk menyimpan catatan
4. **Lihat Daftar Catatan**: Buka drawer/menu untuk melihat semua catatan yang tersimpan
5. **Hapus Catatan**: Swipe atau tap delete pada catatan untuk menghapusnya

## Struktur Proyek

```
lib/
├── main.dart              # File utama, MapScreen dan UI utama
├── catatan_model.dart     # Model data untuk catatan lokasi
test/
├── widget_test.dart       # Test dasar untuk widget
android/
├── app/src/main/
│   └── AndroidManifest.xml # Konfigurasi Android dan permissions
ios/
├── Runner/
│   └── Info.plist         # Konfigurasi iOS (opsional)
```

## Model Data

### CatatanModel

```dart
class CatatanModel {
  final LatLng position;        // Koordinat (latitude, longitude)
  final String note;            // Teks catatan
  final String address;         // Alamat jalan (dari reverse geocoding)
  final String? id;             // ID unik
  final DateTime createdAt;     // Waktu pembuatan
  final String type;            // Tipe lokasi: 'toko', 'rumah', 'kantor', dll
}
```

## Build APK/Aplikasi Release

### Build APK untuk Testing

```bash
flutter build apk --release
```

### Build App Bundle untuk Play Store

```bash
flutter build appbundle --release
```

APK/Bundle akan tersimpan di:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- Bundle: `build/app/outputs/bundle/release/app-release.aab`

## Troubleshooting

### Masalah Izin Lokasi

- Pastikan perangkat/emulator memiliki lokasi GPS aktif
- Untuk emulator, atur lokasi di Android Studio: Extended Controls → Location
- Cek apakah aplikasi sudah diberi izin lokasi di System Settings

### Peta Tidak Tampil

- Pastikan koneksi internet aktif (peta dari OpenStreetMap memerlukan internet)
- Coba restart aplikasi
- Clear cache: `flutter clean` kemudian `flutter pub get`

### Error saat Build

```bash
# Clean dan rebuild
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## Pengembangan Lebih Lanjut

Ide-ide untuk pengembangan:

- [ ] Sinkronisasi dengan cloud (Firebase, Supabase)
- [ ] Export catatan ke format CSV/PDF
- [ ] Fitur pencarian catatan
- [ ] Custom marker untuk tipe lokasi berbeda
- [ ] Notifikasi lokasi
- [ ] Mode offline
- [ ] Sharing lokasi dengan user lain
- [ ] Map clustering untuk catatan yang banyak

## Lisensi

Proyek ini bersifat pribadi. Untuk lisensi, hubungi pemilik repository.

## Kontribusi

Untuk kontribusi atau bug report, buat issue atau pull request di GitHub.

## Kontak

- GitHub: [@zenverovenopasa](https://github.com/zenverovenopasa)
- Repository: [geo](https://github.com/zenverovenopasa/geo)

---

**Terakhir diupdate**: November 2025
