// Import paket yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'catatan_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MapScreen());
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<CatatanModel> _savedNotes = [];
  final MapController _mapController = MapController();
  late SharedPreferences _prefs;

  static const _prefsKey = 'saved_notes';

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _findMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Ambil posisi
    Position position = await Geolocator.getCurrentPosition();

    // Pindahkan kamera peta
    _mapController.move(
      latlong.LatLng(position.latitude, position.longitude),
      15.0,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getStringList(_prefsKey);
    if (raw != null) {
      setState(() {
        _savedNotes.clear();
        for (final s in raw) {
          try {
            final j = jsonDecode(s) as Map<String, dynamic>;
            _savedNotes.add(CatatanModel.fromJson(j));
          } catch (_) {}
        }
      });
    }
  }

  Future<void> _saveNotes() async {
    final list = _savedNotes.map((n) => jsonEncode(n.toJson())).toList();
    await _prefs.setStringList(_prefsKey, list);
  }

  // Fungsi menangani Long Press pada peta
  void _handleLongPress(TapPosition _, latlong.LatLng point) async {
    // Reverse Geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(point.latitude, point.longitude);
    String address = placemarks.first.street ?? "Alamat tidak dikenal";

    // Ask user for type and optional note
    if (!mounted) return;
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (c) {
        String selectedType = 'toko';
        final TextEditingController ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Tambah Catatan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Catatan (opsional)')),
              const SizedBox(height: 8),
              StatefulBuilder(builder: (context, setState) {
                return DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  items: const [
                    DropdownMenuItem(value: 'toko', child: Text('Toko')),
                    DropdownMenuItem(value: 'rumah', child: Text('Rumah')),
                    DropdownMenuItem(value: 'kantor', child: Text('Kantor')),
                  ],
                  onChanged: (v) => setState(() => selectedType = v ?? 'toko'),
                  decoration: const InputDecoration(labelText: 'Tipe'),
                );
              })
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('Batal')),
            TextButton(
                onPressed: () => Navigator.of(c).pop({'note': ctrl.text, 'type': selectedType}),
                child: const Text('Simpan')),
          ],
        );
      },
    );

    if (result == null) return;

    setState(() {
      _savedNotes.add(
        CatatanModel(
          position: point,
          note: result['note']?.isEmpty == true ? 'Catatan Baru' : result['note'] ?? 'Catatan Baru',
          address: address,
          type: result['type'] ?? 'toko',
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );
    });
    await _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geo-Catatan")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const latlong.LatLng(-6.2, 106.8),
          initialZoom: 13.0,
          onLongPress: _handleLongPress,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _savedNotes.map((n) {
              IconData iconData = Icons.location_on;
              Color iconColor = Colors.red;
              switch (n.type) {
                case 'rumah':
                  iconData = Icons.home;
                  iconColor = Colors.green;
                  break;
                case 'kantor':
                  iconData = Icons.business;
                  iconColor = Colors.blue;
                  break;
                case 'toko':
                default:
                  iconData = Icons.store;
                  iconColor = Colors.red;
              }

              return Marker(
                point: n.position,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Hapus Catatan?'),
                        content: Text('${n.note}\n${n.address}'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Batal')),
                          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Hapus')),
                        ],
                      ),
                    );
                    if (shouldDelete == true) {
                      setState(() {
                        _savedNotes.removeWhere((e) => e.id == n.id && e.createdAt == n.createdAt);
                      });
                      await _saveNotes();
                    }
                  },
                  child: Icon(iconData, color: iconColor, size: 32),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
} 
