import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  Future fetchCurrentLocation()
  async {
    if(await askPermission())
      {
        currentPosition = await Geolocator.getCurrentPosition();
        setState(() {});
        final GoogleMapController controller = await _controller.future;
        await controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(currentPosition.latitude , currentPosition.latitude) , zoom: 15)
        ));
      }
  }

  Future<bool> askPermission()
  async
  {
    if(!(await Permission.location.isGranted))
      {
          if(await Permission.location.request() == PermissionStatus.granted)
            {
              return true;
            }
          return false;
      }
    return true;
  }

  addMarker(LatLng latLng) {
    markers.clear();
    markers.add(
        Marker(markerId: MarkerId(latLng.toString()),
            position: LatLng(latLng.latitude, latLng.longitude)
        ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapToolbarEnabled: true,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        onTap: (LatLng latLng){
          addMarker(latLng);
        },
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
        child: Icon(Icons.my_location , color: Colors.black
          ,),
      ),
    );
  }
}
