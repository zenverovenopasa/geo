import 'package:latlong2/latlong.dart';

class CatatanModel {
  final LatLng position;
  final String note;
  final String address;
  final String? id;
  final DateTime createdAt;
  final String type; // e.g. 'toko', 'rumah', 'kantor'

  CatatanModel({
    required this.position,
    required this.note,
    required this.address,
    this.id,
    DateTime? createdAt,
    this.type = 'toko',
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'note': note,
        'address': address,
        'type': type,
        'createdAt': createdAt.toIso8601String(),
        'position': {'lat': position.latitude, 'lng': position.longitude},
      };

  factory CatatanModel.fromJson(Map<String, dynamic> j) {
    final pos = j['position'] as Map<String, dynamic>;
    return CatatanModel(
      id: j['id'] as String?,
      note: j['note'] as String? ?? '',
      address: j['address'] as String? ?? '',
      type: j['type'] as String? ?? 'toko',
      createdAt: j['createdAt'] != null
          ? DateTime.parse(j['createdAt'] as String)
          : DateTime.now(),
      position: LatLng((pos['lat'] as num).toDouble(), (pos['lng'] as num).toDouble()),
    );
  }
}