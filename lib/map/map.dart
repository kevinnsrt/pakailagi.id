import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double lng;

  const MapPage({super.key, required this.lat, required this.lng});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Jika lat/lng berubah → pindahkan kamera
    if (oldWidget.lat != widget.lat || oldWidget.lng != widget.lng) {
      _mapController.move(
        LatLng(widget.lat, widget.lng),
        16, // zoom
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.lat, widget.lng),
        initialZoom: 16,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.tubes_pm',
        ),

        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(widget.lat, widget.lng),
              width: 40,
              height: 40,
              child: Icon(
                Icons.location_pin,
                size: 40,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
