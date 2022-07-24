import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/screens/location_screen.dart';
import 'package:weather_app/services/weather.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: use_key_in_widget_constructors
class LoadingScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late double latitude;
  late double longitude;
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getSnackBar(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      getSnackBar('Location permission denied');
      throw ('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getSnackBar('Location permission denied');
        throw ('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      getSnackBar('Location permission denied');
      throw ('Location permissions are permanently denied, we cannot request permissions.');
    }
    getSnackBar('Location permission accepted');
    var weatherData = await WeatherModel().getLocationWeather();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LocationScreen(
            locationWeather: weatherData,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate state');
  }
}
