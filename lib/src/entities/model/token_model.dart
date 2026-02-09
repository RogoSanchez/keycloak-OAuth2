import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:keycloack_integrations/src/core/constants/keyclock_constants.dart';

/// Modelo que representa los tokens de autenticación de Keycloak
class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String? idToken;
  final DateTime accessTokenExpiry;
  final DateTime? refreshTokenExpiry;
  final List<String> scopes;
  final String tokenType;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    this.idToken,
    required this.accessTokenExpiry,
    this.refreshTokenExpiry,
    this.scopes = const [],
    this.tokenType = 'Bearer',
  });

  /// Crea un TokenModel a partir de la respuesta JSON de Keycloak
  factory TokenModel.fromKeycloakResponse(Map<String, dynamic> json) {
    final accessToken = json['access_token'] as String;
    final refreshToken = json['refresh_token'] as String;
    final idToken = json['id_token'] as String?;
    final expiresIn = json['expires_in'] as int? ?? 300;
    final refreshExpiresIn = json['refresh_expires_in'] as int?;
    final scope = json['scope'] as String? ?? '';
    final tokenType = json['token_type'] as String? ?? 'Bearer';

    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
      accessTokenExpiry: DateTime.now().add(Duration(seconds: expiresIn)),
      refreshTokenExpiry: refreshExpiresIn != null
          ? DateTime.now().add(Duration(seconds: refreshExpiresIn))
          : null,
      scopes: scope.split(' ').where((s) => s.isNotEmpty).toList(),
      tokenType: tokenType,
    );
  }

  /// Crea un TokenModel a partir de datos almacenados
  factory TokenModel.fromStorage({
    required String accessToken,
    required String refreshToken,
    String? idToken,
    required DateTime accessTokenExpiry,
    DateTime? refreshTokenExpiry,
  }) {
    return TokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
      accessTokenExpiry: accessTokenExpiry,
      refreshTokenExpiry: refreshTokenExpiry,
    );
  }

  /// Verifica si el access token es válido (no expirado)
  bool get isAccessTokenValid {
    final margin = Duration(
      seconds: KeyclockConstants.tokenExpiryMarginSeconds,
    );
    return accessTokenExpiry.isAfter(DateTime.now().add(margin));
  }

  /// Verifica si el refresh token es válido (no expirado)
  /// Incluye un margen de seguridad para evitar intentar refresh cuando está por expirar
  bool get isRefreshTokenValid {
    if (refreshTokenExpiry == null) {
      return true; // Asumimos válido si no hay fecha
    }
    // Usar un margen mayor (60 segundos) para el refresh token
    final margin = Duration(days: 7);
    return refreshTokenExpiry!.isAfter(DateTime.now().add(margin));
  }

  /// Verifica si el access token está próximo a expirar (dentro del margen de tiempo)
  /// Esto permite hacer refresh proactivo antes de que expire
  bool get isAccessTokenExpiringSoon {
    // Refrescar cuando falten menos de 2 minutos para expirar
    final soonMargin = Duration(seconds: 120);
    return accessTokenExpiry.isBefore(DateTime.now().add(soonMargin));
  }

  /// Verifica si se necesita refrescar el token
  /// Ahora refresca proactivamente antes de que expire el access token
  bool get needsRefresh => isAccessTokenExpiringSoon && isRefreshTokenValid;

  /// Verifica si la sesión está completamente expirada
  bool get isSessionExpired => !isAccessTokenValid && !isRefreshTokenValid;

  /// Decodifica el access token JWT y retorna los claims
  Map<String, dynamic> get accessTokenClaims {
    try {
      return JwtDecoder.decode(accessToken);
    } catch (_) {
      return {};
    }
  }

  /// Decodifica el ID token JWT y retorna los claims
  Map<String, dynamic>? get idTokenClaims {
    if (idToken == null) return null;
    try {
      return JwtDecoder.decode(idToken!);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene el subject (user ID) del token
  String? get subject => accessTokenClaims['sub'] as String?;

  /// Obtiene el email del token
  String? get email => accessTokenClaims['email'] as String?;

  /// Obtiene el nombre preferido del usuario
  String? get preferredUsername =>
      accessTokenClaims['preferred_username'] as String?;

  /// Obtiene el nombre completo del usuario
  String? get name => accessTokenClaims['name'] as String?;

  /// Obtiene los roles del realm
  List<String> get realmRoles {
    final realmAccess =
        accessTokenClaims['realm_access'] as Map<String, dynamic>?;
    if (realmAccess == null) return [];
    final roles = realmAccess['roles'] as List<dynamic>?;
    return roles?.map((e) => e.toString()).toList() ?? [];
  }

  /// Obtiene los roles de un cliente específico
  List<String> getClientRoles(String clientId) {
    final resourceAccess =
        accessTokenClaims['resource_access'] as Map<String, dynamic>?;
    if (resourceAccess == null) return [];
    final clientAccess = resourceAccess[clientId] as Map<String, dynamic>?;
    if (clientAccess == null) return [];
    final roles = clientAccess['roles'] as List<dynamic>?;
    return roles?.map((e) => e.toString()).toList() ?? [];
  }

  /// Verifica si el usuario tiene un rol específico del realm
  bool hasRealmRole(String role) => realmRoles.contains(role);

  /// Verifica si el usuario tiene un rol específico de un cliente
  bool hasClientRole(String clientId, String role) =>
      getClientRoles(clientId).contains(role);

  /// Convierte el modelo a un Map para almacenamiento
  Map<String, dynamic> toStorageMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'id_token': idToken,
      'access_token_expiry': accessTokenExpiry.toIso8601String(),
      'refresh_token_expiry': refreshTokenExpiry?.toIso8601String(),
      'scopes': scopes.join(' '),
      'token_type': tokenType,
    };
  }

  /// Crea un TokenModel desde un Map de almacenamiento
  factory TokenModel.fromStorageMap(Map<String, dynamic> map) {
    return TokenModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
      idToken: map['id_token'] as String?,
      accessTokenExpiry: DateTime.parse(map['access_token_expiry'] as String),
      refreshTokenExpiry: map['refresh_token_expiry'] != null
          ? DateTime.parse(map['refresh_token_expiry'] as String)
          : null,
      scopes:
          (map['scopes'] as String?)
              ?.split(' ')
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
      tokenType: map['token_type'] as String? ?? 'Bearer',
    );
  }

  @override
  String toString() {
    return 'TokenModel(subject: $subject, email: $email, isValid: $isAccessTokenValid)';
  }
}
