import 'package:shared_preferences/shared_preferences.dart';

class Users {
  static Future<void> setToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', token);
  }

    static Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

    static Future<void> removeToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
  }

  static Future<bool?> getsignin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("Sign-in");
  }

  static Future setsignin(bool signin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("Sign-in", signin);
  }

  static Future logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("Sign-in");
  }
}
