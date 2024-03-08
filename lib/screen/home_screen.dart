import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_work/constant/strings.dart';
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
  bool isWithinRange = false;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
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

            return Stack(
              children: [
                MyGoogleMap(
                  baseLntLng: baseLatLng,
                  onMapCreated: onMapCreated,
                  withinRanged: withinRanged,
                  isDone: isDone,
                ),
                if (!isDone && isWithinRange)
                  Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 50.0,
                    child: _ChoolCheckButton(onPressed: onChoolCheckPressed),
                  )
              ],
            );
          },
        ));
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        HomeScreenString.TITLE,
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
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
          },
          color: Colors.blue,
          icon: const Icon(
            Icons.my_location,
          ),
        ),
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void withinRanged(bool b) {
    // setState(() {
      isWithinRange = b;
    // });
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

class _ChoolCheckButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ChoolCheckButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: onPressed,
      child: const Text(
        HomeScreenString.BUTTON_TITLE,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
