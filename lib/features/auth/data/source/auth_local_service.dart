// lib/features/auth/data/source/auth_local_service.dart

import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalService {
  Future<void> saveToken(String token);
  Future<bool> isLoggedIn();
}


class AuthLocalServiceImpl implements AuthLocalService{
  final SharedPreferences sharedPreferences;
  AuthLocalServiceImpl(this.sharedPreferences);
  
  @override
  Future<bool> isLoggedIn() async {
    final String? token = sharedPreferences.getString('token');
    return token != null && token.isNotEmpty;
  }
  
  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('token', token);
  }
}