import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class LocationService {
  ///---------------------------------------------------------------------------
  static const API_KEY = "AIzaSyCj5MgaAw0oXaiSnYIeNPZnTm6odEguvHk";

  ///---------------------------------------------------------------------------
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  ///---------------------------------------------------------------------------
  ///Get location details
  static Future<GeocodingResponse> getLocationDetails(
      {double lat, double lon}) async {
    GoogleGeocoding googleGeocoding = GoogleGeocoding(API_KEY);
    return await googleGeocoding.geocoding
        .getReverse(LatLon(lat ?? 40.714224, lon ?? -73.961452));
  }

  static Future<Address> getLocationDetailsByGeoCoder(
      {@required double lat, @required double lon}) async {
    Address address;
    try {
      await Geocoder.google(API_KEY)
          .findAddressesFromCoordinates(Coordinates(lat, lon))
          .then((value) {
        if (!GetUtils.isNull(value)) {
          if (value.isNotEmpty) {
            address = value.first;
          }
        }
      });
    } catch (e) {
      log(e.toString(), name: "getLocationDetailsByGeoCoder error");
    }
    return address;
  }

  ///---------------------------------------------------------------------------
  ///Search auto complete
  static Future<Prediction> getPredictionForSearchAutoCompleter(
      BuildContext context) async {
    return await PlacesAutocomplete.show(
        context: context,
        apiKey: API_KEY,
        mode: Mode.overlay,
        language: "en",
        onError: (response) {
          log(response.errorMessage.toString(),
              name: "getPredictionForSearchAutoCompleter error");
        });
  }

  static void mapCameraMoveToLocation(
      LatLng target, Completer<GoogleMapController> mapController) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: target,
        zoom: 17.0,
      ),
    ));
  }
}
