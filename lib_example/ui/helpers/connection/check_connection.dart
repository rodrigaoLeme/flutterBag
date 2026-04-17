import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == [ConnectivityResult.none]) {
    return false;
  }

  bool hasInternet = await InternetConnectionChecker.instance.hasConnection;
  return hasInternet;
}
