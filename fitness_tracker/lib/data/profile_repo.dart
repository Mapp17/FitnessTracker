import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  static const String _key = 'user_profile';
  final SharedPreferences _prefs;

  ProfileRepository(this._prefs);

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  UserProfile loadProfile() {
    try {
      final String? data = _prefs.getString(_key);
      if (data == null) return UserProfile.defaults();
      return UserProfile.fromJson(jsonDecode(data));
    } catch (e) {
      return UserProfile.defaults();
    }
  }

  Future<void> clearProfile() async {
    await _prefs.remove(_key);
  }
}