import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../auth/firebase_auth.dart';

class RestService {
  // Collection and document names
  static const String configCollection = 'config';
  static const String documentId = 'b2c';
  static const String apiBaseURLField = 'apiBaseURL';

  // Private constructor
  RestService._privateConstructor();

  static final RestService _instance = RestService._privateConstructor();

  // Field to hold the fetched baseURL
  String? baseURL;

  //Constructor
  RestService() {
    if (baseURL == null) {
      final currentDomain = html.window.location.hostname;
      if (kIsWeb && currentDomain == 'localhost') {
        // Running locally, set the baseURL to localhost
        baseURL = 'http://localhost:8080/occur/api';
      } else {
        // Fetch the baseURL from Firestore for other domains
        _fetchBaseURL();
      }
    }
  }

  // Method to fetch the baseURL from Firestore
  Future<void> _fetchBaseURL() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> configDoc =
          await FirebaseFirestore.instance
              .collection(configCollection)
              .doc(documentId)
              .get();

      if (configDoc.exists) {
        final data = configDoc.data();
        baseURL = data?[apiBaseURLField] as String?;
      } else {
        // Handle the case where the document doesn't exist or the field is missing.
        baseURL = null;
      }
    } catch (e) {
      // Handle any errors that occur during fetching.
      //print('Error fetching baseURL: $e');
      baseURL = null;
    }
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    var encode = json.encode(body);
    //print("URL -  $baseURL$path");
    print("Request Body : $encode");
    String token = await getJwtTokenSync();
    //print("Received token in post is : $token");
    final response = await http.post(
      Uri.parse('$baseURL$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add JWT bearer token
      },
      body: encode,
    );
    //print("Response Body : ${response.body}");
    return response;
  }

  Future<http.Response> get(String path) async {
    String token = await getJwtTokenSync();
    //print("Received token in get is : $token");
    final response = await http.get(
      Uri.parse('$baseURL$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add JWT bearer token
      },
    );
    //print("Response Body : ${response.body}");
    return response;
  }

  //Method to ftech JWT token from FirebaseAuthHelper based on logged in user.

  Future<String> getJwtTokenSync() async {
    String token = "";
    await FirebaseAuthHelper().getUser!.getIdToken().then((value) {
      //print("Value of the token is : $value");
      token = value.toString();
    });
    return token;
  }
}
