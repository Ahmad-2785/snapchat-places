import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  static Future<void> setUser(String userKey, String uid, String username,
      String avatarURL, bool isPublic) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('USERKEY', userKey);
    pref.setString('UID', uid);
    pref.setString('USERNAME', username);
    pref.setString('AVATARURL', avatarURL);
    pref.setBool('ISPUBLIC', isPublic);
  }

  static Future<Map<String, String>> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return {
      'UID': pref.getString('UID')!,
      'USERNAME': pref.getString('USERNAME')!,
      'AVATARURL': pref.getString('AVATARURL')!,
    };
  }

  static Future<void> removeUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
