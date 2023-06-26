import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utilities/common_widgets.dart';

class FetchLocation extends StatefulWidget {
  const FetchLocation({Key? key}) : super(key: key);

  @override
  State<FetchLocation> createState() => _FetchLocationState();
}

class _FetchLocationState extends State<FetchLocation> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late Position currentPosition;
  Set<Marker> markers = {};
  Set<Polyline> polyline = {};
  Set<Polygon> polygons = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.42796133580664, 73.085749655962),
    zoom: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrentLocation();
  }

  Future fetchCurrentLocation() async {
    polygons.add(const Polygon(
        polygonId: PolygonId("Polygon"),
        fillColor: Colors.transparent,
        strokeColor: Colors.black12,
        strokeWidth: 2,
        points: [
          LatLng(23.009423232090906, 72.59673934665193),
          LatLng(23.00928497708458, 72.60456791181915),
          LatLng(23.00333871274201, 72.60478349699757),
          LatLng(23.003145298412463, 72.59597147637538)
        ]));
    if (await askPermission()) {
      currentPosition = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(
          const CameraPosition(
              target: LatLng(23.009423232090906, 72.59673934665193),
              zoom: 14)));

      setState(() {});
    } else {
      CommonWidgets.showToast("Please allow Permission !");
    }
  }

  Future<bool> askPermission() async {
    if (!(await Permission.location.isGranted)) {
      if (await Permission.location.request() == PermissionStatus.granted) {
        return true;
      }
      return false;
    }
    return true;
  }

  addMarker(LatLng latLng) {
    markers.clear();
    markers.add(Marker(
        onDragEnd: (latlng) {
          log(" *** ${latLng.latitude} - ${latLng.longitude}");
        },
        markerId: MarkerId(latLng.toString()),
        position: LatLng(latLng.latitude, latLng.longitude)));
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, [
          markers.first.position.latitude,
          markers.first.position.longitude,
          currentPosition.latitude,
          currentPosition.longitude
        ]);
        return Future.value(true);
      },
      child: Scaffold(
        body: GoogleMap(
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          onTap: (LatLng latLng) {
            addMarker(latLng);
            CommonWidgets.showToast("Location marked !");
          },
          onCameraIdle: () {
            setState(() {});
          },
          onCameraMove: (position) {
            log("- ${position.target.latitude} - ${position.target.longitude}");
            addMarker(
                LatLng(position.target.latitude, position.target.longitude));
          },
          polylines: polyline,
          polygons: polygons,
          markers: markers,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await fetchCurrentLocation();
          },
          child: const Icon(
            Icons.my_location,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
