import 'dart:convert';

class UserProfileData {
  String firstName;
  String lastName;
  String phoneNumber;

  UserProfileData({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  // Convert UserProfile to JSON string
  String toJsonString() {
    final Map<String, dynamic> jsonMap = toJson();
    return json.encode(jsonMap);
  }

  // Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }

  // Create UserProfile from JSON
  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  // Create UserProfile from JSON string
  factory UserProfileData.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return UserProfileData.fromJson(jsonMap);
  }
}
