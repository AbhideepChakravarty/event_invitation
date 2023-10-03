import 'package:event_invitation/auth/firebase_auth.dart';
import 'dart:convert';
import '../helper/base_rest_service.dart';
import 'user_profile_data.dart';

class UserProfileService extends RestService {
  UserProfileService._privateConstructor() : super();

  static final UserProfileService _instance =
      UserProfileService._privateConstructor();

  factory UserProfileService() {
    return _instance;
  }

  Future<void> createUser(UserProfileData userProfile) async {
    try {
      // Fetch the Firebase logged-in user's phone number (replace with your Firebase logic)
      final String firebasePhoneNumber =
          FirebaseAuthHelper().getUser!.phoneNumber!;

      // Update the phone number in the user profile
      userProfile.phoneNumber = firebasePhoneNumber;

      // Convert UserProfile to JSON
      final Map<String, dynamic> userJson = userProfile.toJson();

      // Make a POST request to create the user profile
      final response = await post('/users', userJson);

      if (response.statusCode == 201) {
        // Successfully created the user profile
        print('User profile created successfully.');
      } else {
        // Handle errors, e.g., failed to create the user profile
        print(
            'Failed to create user profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error creating user profile: $e');
    }
  }

  Future<UserProfileData?> getUserProfile() async {
    try {
      final response = await get('/users');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> userData = json.decode(response.body);
        final UserProfileData userProfile = UserProfileData.fromJson(userData);
        return userProfile;
      }
      if (response.statusCode == 404) {
        // User profile not found
        return null;
      } else {
        throw Exception(
            'Failed to get user profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error getting user profile: $e');
      rethrow; // Re-throw the exception to propagate it to the caller
    }
  }
}
