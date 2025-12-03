import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(AuthTokenModel token);
  Future<AuthTokenModel?> getToken();
  Future<void> deleteToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String>?> getCredentials();
  Future<void> deleteCredentials();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokenBoxName = 'auth_token_box';
  static const _userBoxName = 'auth_user_box';
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _credentialsEmailKey = 'auth_credentials_email';
  static const _credentialsPasswordKey = 'auth_credentials_password';
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<Box> _openTokenBox() async {
    if (Hive.isBoxOpen(_tokenBoxName)) {
      return Hive.box(_tokenBoxName);
    }
    return Hive.openBox(_tokenBoxName);
  }

  Future<Box> _openUserBox() async {
    if (Hive.isBoxOpen(_userBoxName)) {
      return Hive.box(_userBoxName);
    }
    return Hive.openBox(_userBoxName);
  }


  @override
  Future<void> saveToken(AuthTokenModel token) async {
    try {
      final box = await _openTokenBox();
      final tokenMap = token.toMap();
      final encryptedToken = jsonEncode(tokenMap);
      await box.put(_tokenKey, encryptedToken);
    } catch (e) {
      throw CacheException('Failed to save token: ${e.toString()}');
    }
  }

  @override
  Future<AuthTokenModel?> getToken() async {
    try {
      final box = await _openTokenBox();
      final encryptedToken = box.get(_tokenKey) as String?;
      
      if (encryptedToken == null) {
        return null;
      }

      final tokenMap = jsonDecode(encryptedToken) as Map<String, dynamic>;
      return AuthTokenModel.fromMap(tokenMap);
    } catch (e) {
      throw CacheException('Failed to get token: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      final box = await _openTokenBox();
      await box.delete(_tokenKey);
    } catch (e) {
      throw CacheException('Failed to delete token: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final box = await _openUserBox();
      final userJson = jsonEncode(user.toJson());
      await box.put(_userKey, userJson);
    } catch (e) {
      throw CacheException('Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final box = await _openUserBox();
      final userJson = box.get(_userKey) as String?;
      
      if (userJson == null) {
        return null;
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      final box = await _openUserBox();
      await box.delete(_userKey);
    } catch (e) {
      throw CacheException('Failed to delete user: ${e.toString()}');
    }
  }

  @override
  Future<void> saveCredentials(String email, String password) async {
    try {
      await _secureStorage.write(key: _credentialsEmailKey, value: email);
      await _secureStorage.write(key: _credentialsPasswordKey, value: password);
    } catch (e) {
      throw CacheException('Failed to save credentials: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, String>?> getCredentials() async {
    try {
      final email = await _secureStorage.read(key: _credentialsEmailKey);
      final password = await _secureStorage.read(key: _credentialsPasswordKey);
      
      if (email == null || password == null) {
        return null;
      }
      
      return {'email': email, 'password': password};
    } catch (e) {
      throw CacheException('Failed to get credentials: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCredentials() async {
    try {
      await _secureStorage.delete(key: _credentialsEmailKey);
      await _secureStorage.delete(key: _credentialsPasswordKey);
    } catch (e) {
      throw CacheException('Failed to delete credentials: ${e.toString()}');
    }
  }
}

