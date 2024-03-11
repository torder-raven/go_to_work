import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_work/util/check_permission.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../const/locations.dart';
import '../const/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myCurrentPosition = 0;

  List<LatLng> myCurrentLocations = [
    Locations.stationLatLng,
    Locations.middlePointLatLng,
    Locations.companyLatLng,
  ];

  static final CameraPosition initialPosition = CameraPosition(
    target: Locations.companyLatLng,
    zoom: 15,
  );
  static final Marker companyLocationMarker = Marker(
    markerId: const MarkerId(Strings.COMPANY),
    position: Locations.companyLatLng,
  );

  Circle getCircle(String circleId, LatLng center) {
    return Circle(
      circleId: CircleId(circleId),
      center: center,
      fillColor: Colors.blue.withOpacity(0.5),
      radius: 50,
      strokeColor: Colors.blue,
      strokeWidth: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: CheckPermission().checkPermission(),
        builder: (context, snapShot) {
          if (!snapShot.hasData &&
              snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapShot.data == Strings.LOCATION_OK_MSG) {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: initialPosition,
                    markers: {companyLocationMarker},
                    circles: {
                      getCircle(
                          Strings.CIRCLE_ID_STATION, myCurrentLocations[0]),
                      getCircle(Strings.CIRCLE_ID_MIDDLE_POINT,
                          myCurrentLocations[1]),
                      getCircle(
                          Strings.CIRCLE_ID_COMPANY, myCurrentLocations[2]),
                    },
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.timelapse_rounded,
                      color: Colors.purple,
                      size: 50.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    renderElevatedButton()
                  ],
                ))
              ],
            );
          }

          // 권한이 없는 상태
          return Center(
            child: Text(snapShot.data.toString()),
          );
        },
      ),
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      title: const Text(
        Strings.TODAY_ALSO_GO_TO_WORK,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
            onPressed: moveMyCurrentPosition, icon: const Icon(Icons.chevron_right))
      ],
    );
  }

  void moveMyCurrentPosition() {
    myCurrentPosition += 1;
  }

  ElevatedButton renderElevatedButton() {
    return ElevatedButton(
        onPressed: () async {
          final curPosition = myCurrentLocations[myCurrentPosition];

          final distance = Geolocator.distanceBetween(
              curPosition.latitude,
              curPosition.longitude,
              Locations.companyLatLng.latitude,
              Locations.companyLatLng.longitude);

          bool canCheck = distance < 100;

          if (canCheck) {
            showAlertDialog(context, Strings.GO_TO_WORK_SUCCESS);
          } else {
            showAlertDialog(context, Strings.GO_TO_WORK_FAIL);
          }
        },
        child: const Text(
          Strings.GO_TO_WORK,
        ));
  }

  void showAlertDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          content: Text(msg),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
