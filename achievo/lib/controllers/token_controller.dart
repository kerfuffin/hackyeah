// token_controller.dart
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_data.dart';

class TokenController {
  Timer? _timer;
  SharedPreferences? _prefs;
  ValueNotifier<UserData?> userDataNotifier = ValueNotifier(null);

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadUserData(); // Load any saved data
  }

  void startSendingToken() {
    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _sendToken());
    _sendToken(); // Send immediately upon starting
  }

  void stopSendingToken() {
    _timer?.cancel();
  }

  Future<void> _sendToken() async {
    if (_prefs == null) {
      print("SharedPreferences not initialized.");
      return;
    }
    String? token = _prefs!.getString('token');
    if (token == null) {
      print("No token found in SharedPreferences.");
      return;
    }

    Map<String, String> payload = {
      "token": token,
    };

    try {
      final response = await http.post(
        Uri.parse('https://f0f4-188-146-118-195.ngrok-free.app/data'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print("Token sent successfully.");

        // Parse and save the response
        final Map<String, dynamic> responseData = json.decode(response.body);
        UserData userData = UserData.fromJson(responseData);
        await _saveUserData(userData);

        // Notify listeners about the new data
        userDataNotifier.value = userData;
      } else {
        print("Failed to send token. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending token: $e");
    }
  }

  Future<void> _saveUserData(UserData data) async {
    if (_prefs == null) {
      print("SharedPreferences not initialized.");
      return;
    }

    // Convert the data to a JSON string for storage
    String jsonData = json.encode(data.toJson());

    // Save the data to SharedPreferences
    await _prefs!.setString('user_data', jsonData);
    print("User data saved.");
  }

  Future<void> _loadUserData() async {
    if (_prefs == null) {
      print("SharedPreferences not initialized.");
      return;
    }

    String? jsonData = _prefs!.getString('user_data');
    if (jsonData != null) {
      Map<String, dynamic> dataMap = json.decode(jsonData);
      UserData userData = UserData.fromJson(dataMap);
      userDataNotifier.value = userData;
    }
  }

  UserData? getUserData() {
    return userDataNotifier.value;
  }
}
