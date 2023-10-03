import 'package:event_invitation/services/userProfile/user_profile_data.dart';
import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfileData? _userProfileData;

  UserProfileData? get userProfileData => _userProfileData;

  void setUserProfile(UserProfileData? userProfileData) {
    _userProfileData = userProfileData;
    notifyListeners();
  }
}
