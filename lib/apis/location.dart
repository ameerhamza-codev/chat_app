import 'package:location/location.dart';

Future<List<double>> getUserCurrentCoordinates()async{
  List<double> coordinates=[0,0];
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();

  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
  }
  if (_permissionGranted == PermissionStatus.deniedForever) {
    _permissionGranted = await location.requestPermission();
  }

  if(_permissionGranted == PermissionStatus.granted || _permissionGranted == PermissionStatus.grantedLimited){
    print("here");
    await location.getLocation().then((value){
      print("val");
      coordinates[0]=value.latitude!;
      coordinates[1]=value.longitude!;
      //print("lattitue is ${value.latitude!} and longitude is ${value.longitude!}");
    }).onError((error, stackTrace) {
      print("loc error ${error.toString()}");
    });
  }



  return coordinates;
}