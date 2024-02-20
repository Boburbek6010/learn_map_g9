import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomFlutterMap extends StatefulWidget {
  const CustomFlutterMap({super.key});

  @override
  State<CustomFlutterMap> createState() => _CustomFlutterMapState();
}

class _CustomFlutterMapState extends State<CustomFlutterMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(41.326265, 69.228742),
            initialZoom: 17,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            PolygonLayer(
              polygons: [
                Polygon(
                  points: const [
                  LatLng(41.326553, 69.225303),
                  LatLng(41.325223, 69.227630),
                  LatLng(41.326944, 69.230513),
                  LatLng(41.328483, 69.227978),
                ],
                  color: Colors.blueGrey.withOpacity(0.4),
                    borderStrokeWidth: 2,
                    borderColor: Colors.blue,
                    isFilled: true
                )
              ],
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: const LatLng(41.326265, 69.228742),
                  radius: 50,
                  useRadiusInMeter: true,
                  color: Colors.red.withOpacity(0.3),
                  borderColor: Colors.red.withOpacity(0.7),
                  borderStrokeWidth: 2,
                ),

              ],
            ),
            const MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(41.326265, 69.228742),
                  width: 80,
                  height: 80,
                  child: Text("DANGER", style: TextStyle(color: Colors.white),),
                ),
              ],
            )
          ],
      ),
    );
  }
}
