import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myCurrentPosition = 0;
  String btnMsg = "출근하기";

  static final LatLng stationLatLng = LatLng(37.5268, 126.9315); // 회사
  static final LatLng halfDistanceLatLng = LatLng(37.5267, 126.9295); // 중간지점
  static final LatLng companyLatLng = LatLng(37.527, 126.9278); // 여의나루역

  List<LatLng> myCurrentLocations = [
    stationLatLng,
    halfDistanceLatLng,
    companyLatLng
  ];

  static final CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );
  static final Marker companyLocationMarker = Marker(
    markerId: MarkerId('company'),
    position: companyLatLng,
  );

  Circle getCircle(LatLng center) {
    return Circle(
      circleId: CircleId('choolCheckCircle'),
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
        future: checkPermission(),
        builder: (context, snapShot) {
          if (!snapShot.hasData &&
              snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapShot.data == "위치 권한이 허가 되었습니다.") {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: initialPosition,
                    markers: {companyLocationMarker},
                    circles: {
                      getCircle(myCurrentLocations[0]),
                      getCircle(myCurrentLocations[1]),
                      getCircle(myCurrentLocations[2]),
                    },
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timelapse_rounded,
                      color: Colors.purple,
                      size: 50.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final curPosition =
                              myCurrentLocations[myCurrentPosition];

                          final distance = Geolocator.distanceBetween(
                              curPosition.latitude,
                              curPosition.longitude,
                              companyLatLng.latitude,
                              companyLatLng.longitude);

                          bool canCheck = distance < 100;

                          if (canCheck)
                            showAlertDialog(context, "출근 성공!");
                          else
                            showAlertDialog(context, "출근 실패!!!!!");
                        },
                        child: Text(btnMsg)),
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
      title: Text(
        "오늘도 출근",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
            onPressed: moveMyCurrentPosition, icon: Icon(Icons.chevron_right))
      ],
    );
  }

  void moveMyCurrentPosition() {
    myCurrentPosition += 1;
  }

  ElevatedButton renderButton() {
    return ElevatedButton(
        onPressed: () async {
          final curPosition = myCurrentLocations[myCurrentPosition];

          final distance = Geolocator.distanceBetween(
              curPosition.latitude,
              curPosition.longitude,
              companyLatLng.latitude,
              companyLatLng.longitude);

          bool canCheck = distance < 100;

          if (canCheck) {
            showAlertDialog(context, "출근 성공!");
          } else {
            showAlertDialog(context, "출근 실패!!!!!");
          }
        },
        child: Text('출근하기'));
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

Future<String> checkPermission() async {
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationEnabled) {
    return '위치 서비스를 활성화 해주세요.';
  }

  LocationPermission checkedPermission = await Geolocator.checkPermission();

  if (checkedPermission == LocationPermission.denied) {
    checkedPermission = await Geolocator.requestPermission();

    if (checkedPermission == LocationPermission.denied) {
      return '위치 권한을 허가해주세요.';
    }
  }

  if (checkedPermission == LocationPermission.deniedForever) {
    return '앱의 위치 권한을 세팅에서 허가해주세요.';
  }

  return "위치 권한이 허가 되었습니다.";
}
