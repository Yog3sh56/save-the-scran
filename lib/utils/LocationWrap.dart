import 'package:location/location.dart';

class LocationWrap {

  static final LocationWrap _instance = LocationWrap._internal();

  factory LocationWrap()=>_instance;

  Future<LocationData> _uLocation;
  double _lastMaxDistance;

  LocationWrap._internal(){
    _uLocation = getLocation();
    _lastMaxDistance = 2000;
  }


  double getLastDistance()=>_lastMaxDistance;

  void setLastDistance(double newDist) {_lastMaxDistance = newDist;}

  Future<LocationData> staticUserLocation() async{
    var m = await _uLocation;
    return m;
  }





  static Future<LocationData> getLocation() async {
    var _location = Location();
    bool isEnabled = await checkLocationEnabled();
    LocationData location;
    if (isEnabled) {
      location = await _location.getLocation();
    }
    return location;
  }

  //check if location is enabled, returns a future bool
  //if location isn't enabled it asks the user to enable
  static Future<bool> checkLocationEnabled() async {
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
