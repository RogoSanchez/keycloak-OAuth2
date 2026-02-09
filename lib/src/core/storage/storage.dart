import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keycloack_integrations/src/entities/model/token_model.dart';

class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String idToken = 'id_token';
  static const String tokenData = 'token_data';
  static const String userData = 'user_data';
  static const String accessTokenExpiry = 'access_token_expiry';
  static const String refreshTokenExpiry = 'refresh_token_expiry';
}

/// Servicio de almacenamiento seguro para tokens y datos de usuario
class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _localStorage;

  StorageService({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences localStorage,
  }) : _secureStorage = secureStorage,
       _localStorage = localStorage;

  FlutterSecureStorage get getSecure => _secureStorage;
  SharedPreferences get localStorage => _localStorage;


  /// Guarda un valor de forma segura (usa SharedPreferences en web)
  Future<void> _saveSecure(String key, String value) async {
    if (kIsWeb) {
      await _localStorage.setString(key, value);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  /// Lee un valor seguro
  Future<String?> _readSecure(String key) async {
    if (kIsWeb) {
      return _localStorage.getString(key);
    } else {
      return await _secureStorage.read(key: key);
    }
  }

  /// Elimina un valor seguro
  Future<void> _deleteSecure(String key) async {
    if (kIsWeb) {
      await _localStorage.remove(key);
    } else {
      await _secureStorage.delete(key: key);
    }
  }


  /// Guarda el access token
  Future<void> saveAccessToken(String token) async {
    await _saveSecure(StorageKeys.accessToken, token);
  }

  /// Obtiene el access token
  Future<String?> getAccessToken() async {
    return await _readSecure(StorageKeys.accessToken);
  }

  /// Elimina el access token
  Future<void> deleteAccessToken() async {
    await _deleteSecure(StorageKeys.accessToken);
  }


  /// Guarda el refresh token
  Future<void> saveRefreshToken(String token) async {
    await _saveSecure(StorageKeys.refreshToken, token);
  }

  /// Obtiene el refresh token
  Future<String?> getRefreshToken() async {
    return await _readSecure(StorageKeys.refreshToken);
  }

  /// Elimina el refresh token
  Future<void> deleteRefreshToken() async {
    await _deleteSecure(StorageKeys.refreshToken);
  }


  /// Guarda el ID token
  Future<void> saveIdToken(String token) async {
    await _saveSecure(StorageKeys.idToken, token);
  }

  /// Obtiene el ID token
  Future<String?> getIdToken() async {
    return await _readSecure(StorageKeys.idToken);
  }

  /// Elimina el ID token
  Future<void> deleteIdToken() async {
    await _deleteSecure(StorageKeys.idToken);
  }


  /// Guarda todos los tokens como un TokenModel
  Future<void> saveTokens(TokenModel tokens) async {
    final tokenMap = tokens.toStorageMap();
    final jsonString = jsonEncode(tokenMap);
    await _saveSecure(StorageKeys.tokenData, jsonString);

    // También guardamos tokens individuales para acceso rápido
    await saveAccessToken(tokens.accessToken);
    await saveRefreshToken(tokens.refreshToken);
    if (tokens.idToken != null) {
      await saveIdToken(tokens.idToken!);
    }
  }

  /// Obtiene el TokenModel completo
  Future<TokenModel?> getTokens() async {
    final jsonString = await _readSecure(StorageKeys.tokenData);
    if (jsonString == null) return null;

    try {
      final tokenMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return TokenModel.fromStorageMap(tokenMap);
    } catch (e) {
      debugPrint('Error al parsear tokens: $e');
      return null;
    }
  }

  /// Elimina todos los tokens
  Future<void> deleteTokens() async {
    await Future.wait([
      _deleteSecure(StorageKeys.tokenData),
      deleteAccessToken(),
      deleteRefreshToken(),
      deleteIdToken(),
    ]);
  }


  /// Guarda datos de usuario como JSON
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    await _saveSecure(StorageKeys.userData, jsonString);
  }

  /// Obtiene datos de usuario
  Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await _readSecure(StorageKeys.userData);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error al parsear datos de usuario: $e');
      return null;
    }
  }

  /// Elimina datos de usuario
  Future<void> deleteUserData() async {
    await _deleteSecure(StorageKeys.userData);
  }


  /// Verifica si hay una sesión guardada
  Future<bool> hasStoredSession() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  /// Limpia todos los datos de autenticación
  Future<void> clearAllAuthData() async {
    await Future.wait([deleteTokens(), deleteUserData()]);
  }

  /// Verifica si los tokens almacenados siguen siendo válidos
  Future<bool> areTokensValid() async {
    final tokens = await getTokens();
    if (tokens == null) return false;
    return tokens.isAccessTokenValid || tokens.isRefreshTokenValid;
  }
}
