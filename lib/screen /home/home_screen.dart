import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_work/screen%20/constant/text/dialog_text.dart';
import 'package:go_to_work/screen%20/constant/text/label_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/check_permission.dart';
import '../constant/values.dart';
import 'component/app_bar.dart';
import 'component/circles.dart';
import 'component/custom_google_map.dart';
import 'component/go_to_work_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool choolCheckDone = false;
  GoogleMapController? mapController;
  bool isWithinRange = false;

  @override
  void initState() {
    super.initState();

    Geolocator.getCurrentPosition().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(iconButton: Location(onPressed: goToMyLocation)),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == DialogText.REQUEST_PERMISSION_GRANTED) {
            return StreamBuilder<Position>(
              stream: Geolocator.getPositionStream(),
              builder: (context, snapshot) {
                setLocation(snapshot);

                return Column(
                  children: [
                    CustomGoogleMap(
                      circle: choolCheckDone ? checkDoneCircle : isWithinRange ? withinDistanceCircle : notWithinDistanceCircle,
                      onMapCreated: onMapCreated,
                    ),
                    ChoolCheckButton(
                      isWithinRange: isWithinRange,
                      choolCheckDone: choolCheckDone,
                      onPressed: showConfirmDialog,
                    ),
                  ],
                );
              },
            );
          }

          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }

  goToMyLocation() async {
    if (mapController == null) {
      return;
    }

    final location = await Geolocator.getCurrentPosition();

    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          location.latitude,
          location.longitude,
        ),
      ),
    );
  }

  setLocation(AsyncSnapshot<Position> snapshot) {
    if (snapshot.hasData) {
      final start = snapshot.data!;
      final end = Values.companyLatLng;

      final distance = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );

      if (distance < okDistance) {
        isWithinRange = true;
      }
    }
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  showConfirmDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LabelText.GO_TO_WORK),
          content: Text(DialogText.CONFIRM_GO_TO_WORK),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(LabelText.CANCEL),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(LabelText.GO_TO_WORK),
            ),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        choolCheckDone = true;
      });
    }
  }
}