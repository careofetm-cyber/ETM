import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationService {
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org';
  static const String _userAgent = 'ETMTransportApp/1.0';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them in settings.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied. Please grant location access.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied. Please enable it in app settings.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Stream<Position> getLocationStream({int distanceFilter = 10}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse('$_nominatimUrl/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1'),
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'Unknown location';
      }
      return 'Unknown location';
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return 'Error getting address';
    }
  }

  Future<List<Map<String, dynamic>>> searchAddress(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_nominatimUrl/search?format=json&q=${Uri.encodeComponent(query)}&limit=5&addressdetails=1'),
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => {
          'address': item['display_name'] ?? '',
          'latitude': double.parse(item['lat'].toString()),
          'longitude': double.parse(item['lon'].toString()),
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Address search error: $e');
      return [];
    }
  }

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    try {
      final response = await http.get(
        Uri.parse('$_nominatimUrl/search?format=json&q=${Uri.encodeComponent(address)}&limit=1'),
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return LatLng(
            double.parse(data[0]['lat'].toString()),
            double.parse(data[0]['lon'].toString()),
          );
        }
        throw Exception('No results found');
      }
      throw Exception('Geocoding request failed');
    } catch (e) {
      throw Exception('Error getting coordinates: $e');
    }
  }

  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  double calculateBearing(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.bearingBetween(startLat, startLng, endLat, endLng);
  }

  Future<double> getDistanceToDestination(double currentLat, double currentLng, double destLat, double destLng) async {
    double distanceInMeters = calculateDistance(currentLat, currentLng, destLat, destLng);
    return distanceInMeters / 1000;
  }

  Future<int> getETA(double currentLat, double currentLng, double destLat, double destLng, {double averageSpeedKmh = 30}) async {
    double distanceKm = await getDistanceToDestination(currentLat, currentLng, destLat, destLng);
    double timeInHours = distanceKm / averageSpeedKmh;
    return (timeInHours * 60).round();
  }
}

class MapUtils {
  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }
}
