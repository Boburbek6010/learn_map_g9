import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

class CustomYandexMap extends StatefulWidget {
  const CustomYandexMap({super.key});

  @override
  State<CustomYandexMap> createState() => _CustomYandexMapState();
}

class _CustomYandexMapState extends State<CustomYandexMap> {
  late Position myPosition;
  bool isLoading = false;
  late YandexMapController yandexMapController;
  List<MapObject> mapObjects = [];

  Future<Position> _determinePosition() async {
    isLoading = false;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    myPosition = await Geolocator.getCurrentPosition();
    isLoading = true;
    setState(() {});
    return myPosition;
  }

  void onMapCreated(YandexMapController controller){
    yandexMapController = controller;
    BoundingBox boundingBox = const BoundingBox(
      northEast: Point(
          latitude: 41.316830,
          longitude: 69.255045,),
      southWest: Point(
        latitude: 41.316830,
        longitude: 69.255045,),
    );

    controller.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    controller.moveCamera(
      CameraUpdate.zoomTo(12),
    );
  }

  void findMe(){
    BoundingBox boundingBox = BoundingBox(
      northEast: Point(
          latitude: myPosition.latitude,
          longitude: myPosition.longitude),
      southWest: Point(
          latitude: myPosition.latitude,
          longitude: myPosition.longitude),
    );

    yandexMapController.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.zoomTo(18),
    );
    // yandexMapController.moveCamera(
    //   CameraUpdate.tiltTo(50),
    //   animation: const MapAnimation(
    //     type: MapAnimationType.smooth,
    //     duration: 2,
    //   ),
    // );
    putLabel();
  }
  
  void putLabel(){
    PlacemarkMapObject placemarkMapObject = PlacemarkMapObject(
        mapId: const MapObjectId("myLocation"), 
      point: Point(
        latitude: myPosition.latitude,
        longitude: myPosition.longitude,
      ),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage("assets/images/img.png"),
          scale: 0.4,
        )
      )
    );
    log("message");
    
    mapObjects.add(placemarkMapObject);
    setState(() {});
  }

  void putLabelOnTap(Point point){
    PlacemarkMapObject placemarkMapObject = PlacemarkMapObject(
        mapId: MapObjectId(point.longitude.toString()),
        point: point,
        opacity: 1,
        icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage("assets/images/img.png"),
              scale: 0.4,
            )
        )
    );
    log("message");
    mapObjects.add(placemarkMapObject);
    mapObjects.removeRange(1, mapObjects.length-1);
    setState(() {});
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? YandexMap(
        // tiltGesturesEnabled: false,
              // nightModeEnabled: true,
              // mode2DEnabled: false,
              // scrollGesturesEnabled: false,
              // zoomGesturesEnabled: false,
              // rotateGesturesEnabled: false,
        mapObjects: mapObjects,
              onMapTap: putLabelOnTap,
              onMapCreated: onMapCreated,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => yandexMapController.moveCamera(
              CameraUpdate.zoomIn()
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 30,),
          FloatingActionButton(
            onPressed: () => findMe(),
            child: const Icon(Icons.location_on),
          ),
          const SizedBox(height: 30,),
          FloatingActionButton(
            onPressed: () => yandexMapController.moveCamera(
                CameraUpdate.zoomOut()
            ),
            child: const Icon(CupertinoIcons.minus),
          ),
        ],
      ),
    );
  }
}
