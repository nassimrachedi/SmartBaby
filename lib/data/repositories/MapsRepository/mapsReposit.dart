import 'dart:async';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationRepository {
  final Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  final PolylinePoints _polylinePoints = PolylinePoints();

  Future<void> initLocationAndPolyline(Function(LatLng) onLocationUpdate, Function(List<LatLng>) onPolylineUpdate) async {
    LatLng? currentPosition = await getCurrentLocation();
    if (currentPosition != null) {
      onLocationUpdate(currentPosition);
      List<LatLng> polylineCoordinates = await getPolylinePoints(currentPosition, LatLng(37.3346, -122.0090));  // Example destination
      onPolylineUpdate(polylineCoordinates);
    }
  }

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    final LocationData locationData = await _locationController.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<List<LatLng>> getPolylinePoints(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD5sCgh_WY_JWvTgupc5YqZoqEKFXIb968',
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage ?? "Failed to fetch polyline");
    }
    return polylineCoordinates;
  }

  Future<void> cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 13,)));
  }

  void completeMapController(GoogleMapController controller) {
    _mapController.complete(controller);
  }
}
