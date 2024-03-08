import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_work/component/go_to_work.dart';
import 'package:go_to_work/resource/strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../component/my_google_map.dart';
import '../model/location_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGoToWorkDone = false;
  GoogleMapController? mapController;

  // latitude - 위도
  // longitude - 경도

  static const LatLng companyLetLng = LatLng(
    37.5233273,
    126.921252,
  );

  static const CameraPosition initialPosition = CameraPosition(
    target: companyLetLng,
    zoom: 15,
  );

  static const double canGoToWorkDistanceInMeter = 100;

  // Circle copyWith를 할 경우 circelId 재설정이 불가능 ㅠ
  static final Circle withInDistanceCircle = Circle(
    circleId: const CircleId(
      "withInDistanceCircle",
    ),
    center: companyLetLng,
    fillColor: Colors.blue.withOpacity(0.25),
    radius: canGoToWorkDistanceInMeter,
    strokeColor: Colors.blue.withOpacity(1),
    strokeWidth: 1,
  );

  Circle notWithInDistanceCircle = Circle(
    circleId: const CircleId(
      "notWithInDistanceCircle",
    ),
    center: companyLetLng,
    fillColor: Colors.red.withOpacity(0.25),
    radius: canGoToWorkDistanceInMeter,
    strokeColor: Colors.red.withOpacity(1),
    strokeWidth: 1,
  );

  static final Circle goToWorkDoneCircle = Circle(
    circleId: const CircleId(
      "goToWorkDoneCircle",
    ),
    center: companyLetLng,
    fillColor: Colors.green.withOpacity(0.25),
    radius: canGoToWorkDistanceInMeter,
    strokeColor: Colors.green.withOpacity(1),
    strokeWidth: 1,
  );

  static const Marker marker = Marker(
    markerId: MarkerId("marker"),
    position: companyLetLng,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder(
        future: checkLocationPermission(),
        builder: (BuildContext context, AsyncSnapshot<LocationState> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final LocationState? locationState = snapshot.data;
          return switch (locationState.runtimeType) {
            LocationDisabled || DeniedForever => renderNotice(locationState),
            Denied => Center(
                child: Text(
                  "${locationState?.message}",
                  textAlign: TextAlign.center,
                ),
              ),
            _ => StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  final Position? position = snapshot.data;
                  final isWithInRange =
                      position != null ? calculateRange(position) : false;

                  return Column(
                    children: [
                      MyGoogleMap(
                        initialPosition: initialPosition,
                        circle: isGoToWorkDone
                            ? goToWorkDoneCircle
                            : (isWithInRange
                                ? withInDistanceCircle
                                : notWithInDistanceCircle),
                        marker: marker,
                        onMapCreated: onMapCreated,
                      ),
                      GoToWorkButton(
                        isWithInRange: isWithInRange,
                        isCheckDone: isGoToWorkDone,
                        onGoToWorkPressed: onGoToWorkPress,
                        onGoToHomePressed: onGoToHomePress,
                      ),
                    ],
                  );
                },
              ),
          };
        },
      ),
    );
  }

  Future<LocationState> requestPermission() async {
    await Geolocator.requestPermission();
    return checkLocationPermission();
  }

  Future<LocationState> checkLocationPermission() async {
    LocationState locationState = (await Geolocator.isLocationServiceEnabled())
        ? (await Geolocator.checkPermission()).toLocationState()
        : LocationDisabled();

    return switch (locationState) {
      Denied() => await requestPermission(),
      _ => locationState
    };
  }

  bool calculateRange(Position position) {
    final start = position;
    const end = companyLetLng;

    final distance = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return distance < canGoToWorkDistanceInMeter;
  }

  onMoveCameraToCurrentPosition() async {
    final currentLocation = await Geolocator.getCurrentPosition();
    setState(() {
      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            currentLocation.latitude,
            currentLocation.longitude,
          ),
        ),
      );
    });
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          onPressed: onMoveCameraToCurrentPosition,
          icon: const Icon(
            Icons.my_location_rounded,
            color: Colors.white,
          ),
        ),
      ],
      title: const Text(
        Strings.APP_TITLE,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget renderNotice(LocationState? locationState) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "${locationState?.message}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {
              switch (locationState.runtimeType) {
                case LocationDisabled:
                  Geolocator.openLocationSettings();
                  break;
                case DeniedForever:
                  Geolocator.openAppSettings();
                  break;
              }
            },
            child: const Text(
              Strings.MESSAGE_GO_TO_LOCATION_SETTING,
            ),
          ),
        ],
      ),
    );
  }

  onGoToWorkPress() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Strings.TITLE_GO_TO_WORK,
          ),
          content: const Text(
            Strings.MESSAGE_GO_TO_WORK,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                Strings.TEXT_CANCEL,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                Strings.TEXT_GO_TO_WORK,
              ),
            ),
          ],
        );
      },
    );

    setState(() {
      isGoToWorkDone = result;
    });
  }

  onGoToHomePress() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            Strings.TITLE_GO_TO_HOME,
          ),
          content: const Text(
            Strings.MESSAGE_GO_TO_HOME,
          ),
          actions: [
            TextButton(
              onPressed: () {
                print("퇴근 불가 ㅎㅎ");
              },
              child: const Text(
                Strings.TEXT_GO_TO_HOME,
              ),
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

// 출근하기
// 퇴근하기
// 출/퇴근 시 시간 찍기
