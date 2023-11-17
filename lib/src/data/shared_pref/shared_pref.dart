import 'package:shared_preferences/shared_preferences.dart';

class UserPref{
  static Future<void> setUser(String uid, String UserID, String providerId,String username,String password, String avatarURL) async {

    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString('USERID', UserID);
    pref.setString('UID', uid);
    pref.setString('PROVIDERID', providerId);
    pref.setString('USERNAME', username);
    pref.setString('PASSWORD', password);
    pref.setString('AVATARURL', avatarURL);
  }

  static Future<Map<String,String>> getUser() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    return {
      'UID' : pref.getString('UID')!,
      'USERID' : pref.getString('USERID')!,
      'PROVIDERID' : pref.getString('PROVIDERID')!,
      'USERNAME' : pref.getString('USERNAME')!,
      'PASSWORD' : pref.getString('PASSWORD')!,
      'AVATARURL' : pref.getString('AVATARURL')!,
    };
  }

  static Future<void> removeUser() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.clear();
  }


}