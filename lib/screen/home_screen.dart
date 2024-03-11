import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to_work/util/check_permission.dart';
import 'package:go_to_work/util/dialog_util.dart';

import '../component/custom_googlemap.dart';
import '../const/locations.dart';
import '../const/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myCurrentPosition = 0;
  CustomGoogleMap customGoogleMap = CustomGoogleMap()..myCurrentPosition = 0;
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
                Expanded(flex: 2, child: customGoogleMap),
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
            onPressed: () {
              myCurrentPosition++;
              customGoogleMap.myCurrentPosition = myCurrentPosition;
            },
            icon: const Icon(Icons.chevron_right))
      ],
    );
  }

  ElevatedButton renderElevatedButton() {
    return ElevatedButton(
        onPressed: () async {
          final curPosition = Locations.myCurrentLocations[myCurrentPosition];

          final distance = Geolocator.distanceBetween(
              curPosition.latitude,
              curPosition.longitude,
              Locations.companyLatLng.latitude,
              Locations.companyLatLng.longitude);

          bool canChoolCheck = distance < 100;

          if (canChoolCheck) {
            DialogUtil().showAlertDialog(context, Strings.GO_TO_WORK_SUCCESS);
          } else {
            DialogUtil().showAlertDialog(context, Strings.GO_TO_WORK_FAIL);
          }
        },
        child: const Text(
          Strings.GO_TO_WORK,
        ));
  }
}
