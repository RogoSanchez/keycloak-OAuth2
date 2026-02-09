import 'package:flutter/foundation.dart';

/// Configuración de Keycloak para la aplicación
///
class KeyclockConstants {
  KeyclockConstants._();

  /// URL base del servidor Keycloak
  static const String serverUrl = (kIsWeb)
      ? 'http://localhost:8080'
      : 'http://10.0.2.2:8080';

  /// Nombre del realm en Keycloak
  static const String realm = 'flutter-app';

  /// Client ID registrado en Keycloak
  static const String clientId = 'klk_client';

  static const String? clientSecret = null;

  /// URL base del realm
  static String get realmUrl => '$serverUrl/realms/$realm';

  /// URL del endpoint OpenID Connect
  static String get openIdConnectUrl => '$realmUrl/protocol/openid-connect';

  /// URL para obtener tokens
  static String get tokenUrl => '$openIdConnectUrl/token';

  /// URL para autorización
  static String get authorizationUrl => '$openIdConnectUrl/auth';

  /// URL para logout
  static String get logoutUrl => '$openIdConnectUrl/logout';

  /// URL para obtener información del usuario
  static String get userInfoUrl => '$openIdConnectUrl/userinfo';

  /// URL para introspección de tokens

  /// URL del discovery document (well-known)
  static String get discoveryUrl =>
      '$realmUrl/.well-known/openid-configuration';

  /// Scopes solicitados durante la autenticación
  static const List<String> scopes = [
    'openid',
    'profile',
    'email',
    'offline_access', // Necesario para refresh tokens
  ];

  /// Redirect URI para el callback de autenticación
  /// En web usa la URL actual, en mobile usa custom scheme
  static String get redirectUri {
    if (kIsWeb) {
      // Para web, usa la URL base de tu aplicación
      return 'http://localhost:3000/callback';
    }
    return 'com.flutter.app://callback';
  }

  /// Post logout redirect URI
  static String get postLogoutRedirectUri {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    return '$clientId://logout-callback';
  }

  /// Margen de tiempo (en segundos) antes de que expire el token
  static const int tokenExpiryMarginSeconds = 30;

  /// Tiempo máximo de espera para requests (en segundos)
  static const int requestTimeoutSeconds = 30;
}
