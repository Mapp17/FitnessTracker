import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../data/profile_repo.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;
  late UserProfile _profile;

  ProfileProvider(this._repository) {
    _profile = _repository.loadProfile();
  }

  UserProfile get profile => _profile;

  void updateName(String newName) {
    _profile = _profile.copyWith(name: newName);
    _saveAndNotify();
  }

  void updateRestTimer(int seconds) {
    _profile = _profile.copyWith(restTimerSeconds: seconds.clamp(15, 300));
    _saveAndNotify();
  }

  void toggleNotifications(bool value) {
    _profile = _profile.copyWith(notificationsEnabled: value);
    _saveAndNotify();
  }

  void _saveAndNotify() {
    notifyListeners();
    _repository.saveProfile(_profile);
  }
}