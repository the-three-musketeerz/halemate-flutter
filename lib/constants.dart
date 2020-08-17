import 'package:flutter/material.dart';

const colorLight = const Color(0xff30bfbf);
const colorDark = const Color(0xff008c8c);

//API endpoints

const String baseAPI = "http://halemate-backend.southeastasia.cloudapp.azure.com:8000/halemate";

const String loginAPI = '$baseAPI/login/';
const String signupAPI = '$baseAPI/signup/';
const String forgotPasswordAPI = '$baseAPI/forgot_password/';
const String signupVerifyAPI = '$baseAPI/signup_verify/';
const String otpVerifyAPI = '$baseAPI/otp_verify/';
const String otpRefreshAPI = '$baseAPI/otp_refresh/';
const String logoutAPI = '$baseAPI/logout/';
const String appointmentAPI = '$baseAPI/appointment/';
const String hospitalAPI = '$baseAPI/hospital/';
