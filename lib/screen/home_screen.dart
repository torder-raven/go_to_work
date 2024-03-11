import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_work/constant/strings.dart';
import 'package:go_to_work/screen/widget/chool_check_button.dart';
import 'package:go_to_work/screen/widget/home_app_bar.dart';
import 'package:go_to_work/screen/widget/my_google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constant/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LatLng baseLatLng = LatLng(
      MyGoogleMapConstants.BASE_LATITUDE, MyGoogleMapConstants.BASE_LONGITUDE);
  GoogleMapController? googleMapController;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppBar(onCurrentPositionPressed: onCurrentPositionPressed),
        body: FutureBuilder(
          future: checkPermission(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            return homeBody();
          },
        ));
  }

  void onCurrentPositionPressed() async {
    if (googleMapController == null) {
      return;
    }

    final location = await Geolocator.getCurrentPosition();

    googleMapController!.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          location.latitude,
          location.longitude,
        ),
      ),
    );
  }

  Widget homeBody() {
    return StreamBuilder(
      stream: Geolocator.getPositionStream(),
      builder: (context, snapshot) {
        bool withinRanged = false;
        if (snapshot.hasData) {
          withinRanged = checkLocation(snapshot.data!);
        }

        return Stack(
          children: [
            MyGoogleMap(
              baseLntLng: baseLatLng,
              onMapCreated: onMapCreated,
              isWithin: withinRanged,
              isDone: isDone,
            ),
            if (!isDone && withinRanged)
              Positioned(
                left: 20.0,
                right: 20.0,
                bottom: 50.0,
                child: ChoolCheckButton(onPressed: onChoolCheckPressed),
              ),
          ],
        );
      },
    );
  }

  bool checkLocation(Position position) {
    final start = position;
    const end = baseLatLng;

    final distance = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    return distance <= MyGoogleMapConstants.OK_DISTANCE;
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void onChoolCheckPressed() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(HomeScreenString.DIALOG_TITLE),
          content: const Text(HomeScreenString.DIALOG_MESSGE),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(HomeScreenString.DIALOG_CANCLE),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(HomeScreenString.DIALOG_CONFIRM),
            ),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        isDone = true;
      });
    }
  }

  Future<bool> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      throw const PermissionDeniedException(
          PermissionString.MESSAGE_REQUEST_PERMISSION_LOCATION);
    }

    LocationPermission checkPermission = await Geolocator.checkPermission();

    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();

      if (checkPermission == LocationPermission.denied) {
        throw const PermissionDeniedException(
            PermissionString.MESSAGE_REQUEST_PERMISSION_LOCATION);
      }
    }

    if (checkPermission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException(
          PermissionString.MESSAGE_REQUEST_PERMISSION_LOCATION_IN_SETTING);
    }

    return true;
  }
}
