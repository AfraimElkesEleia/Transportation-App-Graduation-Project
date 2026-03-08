import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:transportation_app/features/signup/domain/entities/user_entity.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();
  static const _refreshTokenKey = "refresh_token";
  static const _accessTokenKey = "access_token";
  static const _rememberMeKey = "remember_me";
  static const _cachedUserKey = "cached_user";

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  Future<void> saveRememberMe(bool value) async {
    await _storage.write(key: _rememberMeKey, value: value.toString());
  }

  Future<bool> getRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == 'true';
  }

  Future<void> saveUser(UserEntity user) async {
    final map = {
      'userId': user.userId,
      'email': user.email,
      'fullName': user.fullName,
      'phoneNumber': user.phoneNumber,
      'gender': user.gender,
      'countryCode': user.countryCode,
      'countryName': user.countryName,
    };
    await _storage.write(key: _cachedUserKey, value: jsonEncode(map));
  }

  Future<UserEntity?> getUser() async {
    final raw = await _storage.read(key: _cachedUserKey);
    if (raw == null) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserEntity(
      userId: map['userId'] as int,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      gender: map['gender'] as String,
      countryCode: map['countryCode'] as String,
      countryName: map['countryName'] as String,
    );
  }

  Future<void> clearAllTokens() async {
    await _storage.deleteAll();
  }
}
