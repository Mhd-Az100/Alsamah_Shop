import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final Function(Completer<GoogleMapController> completer) mapController;
  final Function(LatLngBounds, LatLng) latLngBoundsCallback;
  final Function(LatLng) onTabCallback;
  final LatLng defaultCameraTarget;
  final Set<Marker> markers;
  void Function(CameraPosition) onCameramove;
  void Function() onCameraidle;
  MapWidget({
    Key key,
    this.mapController,
    this.latLngBoundsCallback,
    this.onTabCallback,
    this.defaultCameraTarget,
    this.markers,
    this.onCameramove,
    this.onCameraidle,
  }) : super(key: key);

  ///---------------------------------------------------------------------------
  static const LatLng _DefaultCameraTarget =
      LatLng(37.42796133580664, -122.085749655962);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  Position position;
  Widget _child;

  ///---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return _child;
  }

  Widget mapWidget() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      trafficEnabled: true,
      mapToolbarEnabled: true,
      onCameraMove: widget.onCameramove,
      onCameraIdle: widget.onCameraidle,
      minMaxZoomPreference: MinMaxZoomPreference(5, 30),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        widget.mapController(_controller);
      },
      onTap: widget.onTabCallback,
      markers: widget.markers,
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude) ??
            MapWidget._DefaultCameraTarget,
        //  widget.defaultCameraTarget ?? MapWidget._DefaultCameraTarget,
        zoom: 15.2,
      ),
    );
  }

  void currentLocationView() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  @override
  void initState() {
    super.initState();
    _child = Center(
      child: CircularProgressIndicator(),
    );
    currentLocationView();
  }
}
