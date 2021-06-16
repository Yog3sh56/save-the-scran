import 'package:location/location.dart';

class LocationWrap {
  static Future<LocationData> getLocation() async {
    var _location = Location();
    bool isEnabled = await checkLocationEnabled();
    LocationData location;
    if (isEnabled) {
      print("location enabled");
      location = await _location.getLocation();
    }
    return location;
  }

  //check if location is enabled, returns a future bool
  //if location isn't enabled it asks the user to enable
  static Future<bool> checkLocationEnabled() async {
    print("checking location");
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}
