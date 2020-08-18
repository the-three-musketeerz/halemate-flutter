import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hale_mate/base/constants.dart';
import 'package:hale_mate/models/user/User.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStatus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Unregistered
}

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  String _token;
  User _userProfile;
  AuthStatusText _notification;

  Status get status => _status;
  String get token => _token;
  AuthStatusText get notification => _notification;
  User get userProfile => _userProfile;

  initAuthProvider() async {
    String token = await getToken();
    if (token != null) {
      _token = token;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  //Future<void> getUser : sets the user profile from whoami API
  Future<void> getUser() async {
    final url = whoamiAPI;
    String token = await getToken();
    String header = "token $token";

    final response = await http.get(url, headers: {"Authorization": header});

    if (response.statusCode == 200) {
      print("called getUser");

      dynamic a = json.decode(response.body);

      Map<String, dynamic> apiResponse = (json.decode(response.body))[0];
      User newUser = new User(
          email: apiResponse['email'],
          medicalRecord: apiResponse['medical_history'],
          userId: apiResponse['id'],
          name: apiResponse['name'],
          phoneNumber: apiResponse['phoneNumber']);
      _userProfile = newUser;
      await storeUserId(apiResponse);
      notifyListeners();
    }
  }

  //Future<bool> updateUserProfile : updates the profile involving medical
  Future<bool> updateUserMedicalRecord(String medicalHistory) async {
    final url = loginAPI; //needs to be changed
    String token = await getToken();
    String header = "token $token";

    Map<String, String> body = {
      "medical_history": medicalHistory,
    };

    final response =
        await http.post(url, headers: {"Authorization": header}, body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      _userProfile.medicalRecord = apiResponse['medical_history'];
      return true;
    }

    return false;
  }

  //Future<bool> updateTrustedContact : updated the list of trusted contacts
  //for that user
  Future<void> updateTrustedContact(List<TrustedContacts> contacts) async {
    contacts.map((e) => e.toJson());
    List<Map<String, dynamic>> body;

    int userId = await getUserId();

    contacts.map((e) => body.add(e.toJson()));
    body.map((e) => e['user'] = userId);

    String token = await getToken();
    String header = "token $token";

    final url = trustedContactAPI;

    final response =
        await http.post(url, headers: {"Authorization": header}, body: body);

    if (response.statusCode == 201) {
      //Trusted Contacts updated successfully!
      _userProfile.trustedContacts = contacts;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _status = Status.Authenticating;
    _notification = null;
    notifyListeners();

    final url = loginAPI;

    Map<String, String> body = {
      'username': email,
      'password': password,
    };

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);
      _token = apiResponse['token'];
      print(_token);
      await storeUserData(apiResponse);
      _status = Status.Authenticated;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 400) {
      _status = Status.Unauthenticated;
      _notification = AuthStatusText('Invalid email or password.');
      notifyListeners();
      return false;
    }

    _status = Status.Unauthenticated;
    _notification = AuthStatusText(
        'An unknown error occured! Please try again in sometime');
    notifyListeners();
    return false;
  }

  Future<Map> register(String name, String email, String password,
      String passwordConfirm, String phone) async {
    _notification = null;
    final url = signupAPI;

    {
      Map<String, String> body = {
        'name': name,
        'email': email,
        'password': password,
        'phoneNumber': phone,
        'registered_as': "U"
      };

      Map<String, dynamic> result = {
        "success": false,
        "message":
            'Email already exists. Try registering with a different email'
      };

      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        _notification = AuthStatusText(
            'Registration successful, please log in.',
            type: 'info');
        notifyListeners();
        result['success'] = true;
        return result;
      }

      if (response.statusCode == 400) {
        _notification = AuthStatusText(
            'Email already registered! Try registering with a different email',
            type: 'error');
        notifyListeners();
        result['success'] = true;
        return result;
      }

      Map apiResponse = json.decode(response.body);

      if (response.statusCode == 422) {
        if (apiResponse['errors'].containsKey('email')) {
          result['message'] = apiResponse['errors']['email'][0];
          return result;
        }

        if (apiResponse['errors'].containsKey('password')) {
          result['message'] = apiResponse['errors']['password'][0];
          return result;
        }

        return result;
      }

      return result;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _notification = null;
    final url = forgotPasswordAPI;

    Map<String, String> body = {'email': email};

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      _notification = AuthStatusText(
          'Email sent for password reset. If you did not receive the email, please recheck the email entered.',
          type: 'info');
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> resetPassword(
      String email, String OTP, String newPassword) async {
    final url = resetPasswordAPI;

    Map<String, String> body = {
      'OTP': OTP,
      'email': email,
      'new_password': newPassword
    };

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      _notification = AuthStatusText(
          'Your Password has been reset successfully! Login to continue',
          type: 'info');
      notifyListeners();
      return true;
    }

    if (response.statusCode == 409) {
      _notification = AuthStatusText('Invalid OTP! Please enter correct OTP',
          type: 'error');
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final url = changePasswordAPI;

    String token = await getToken();
    String header = "token $token";

    Map<String, String> body = {
      'old_password': oldPassword,
      'new_password': newPassword
    };

    final response = await http.post(
      url,
      headers: {"Authorization": header},
      body: body,
    );

    if (response.statusCode == 200) {
      _notification = AuthStatusText(
          'Your Password has been reset successfully! Login to continue',
          type: 'info');
      notifyListeners();
      return true;
    }

    if (response.statusCode == 409) {
      _notification = AuthStatusText('Invalid OTP! Please enter correct OTP',
          type: 'error');
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendOTP(String method, String email) async {
    _notification = null;
    final url = signupVerifyAPI;

    Map<String, String> body = {'email': email, 'verification_method': method};

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      _notification =
          AuthStatusText('OTP sent. Please enter OTP!', type: 'info');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> verifyOTP(String OTP, String email) async {
    final url = otpVerifyAPI;

    Map<String, dynamic> body = {'email': email, 'OTP': OTP};

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      _notification =
          AuthStatusText('OTP verification successful!', type: 'info');
      notifyListeners();
      return true;
    }

    if (response.statusCode == 409) {
      _notification = AuthStatusText('Invalid OTP! Please enter correct OTP',
          type: 'error');
      notifyListeners();
      return false;
    }
  }

  Future<bool> refreshOTP(String method, String email) async {
    final url = otpRefreshAPI;

    Map<String, String> body = {'email': email, 'verification_method': method};

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      _notification = AuthStatusText('New OTP sent successfully. Please check!',
          type: 'info');
      notifyListeners();
      return true;
    }
  }

  Future<bool> registerDevice(dynamic fcmToken) async {
    final url = registerDeviceAPI;

    Map<String, String> body = {'registration_id': fcmToken, 'type': "android"};
    String token = await getToken();
    String header = "token $token";

    final response =
        await http.post(url, headers: {"Authorization": header}, body: body);

    if (response.statusCode == 200 || response.statusCode == 401) {
      return true;
    }
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', apiResponse['token']);
  }

  storeUserId(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setInt('id', apiResponse['id']);
  }

  Future<String> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token');
    return token;
  }

  Future<int> getUserId() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    int userId = storage.getInt('id');
    return userId;
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification =
          AuthStatusText('Session expired. Please log in again.', type: 'info');
    }
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}
