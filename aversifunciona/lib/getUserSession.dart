import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail');
}
Future<String?> getUserPassword() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userPassword');
}