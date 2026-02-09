import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:keycloack_integrations/src/core/constants/keyclock_constants.dart';
import 'package:keycloack_integrations/src/core/exceptions/error_handling.dart';
import 'package:keycloack_integrations/src/core/exceptions/exceptions.dart';
import 'package:keycloack_integrations/src/core/storage/storage.dart';
import 'package:keycloack_integrations/src/entities/model/token_model.dart';

/// Servicio abstracto para la integración con Keycloak
///
/// Proporciona métodos para:
/// - Login con OAuth2/OIDC (Authorization Code Grant con PKCE)
/// - Refresh de tokens
/// - Logout
/// - Obtención de información del usuario
abstract class AbstractKeycloakService {
  @protected
  final Dio dio;
  @protected
  final StorageService storageService;

  @protected
  TokenModel? currentTokenInternal;

  TokenModel? get currentToken => currentTokenInternal;
  bool get isAuthenticated => currentTokenInternal?.isAccessTokenValid ?? false;

  AbstractKeycloakService({required this.dio, required this.storageService});

  @protected
  Future<void> saveToken(TokenModel token) async {
    currentTokenInternal = token;
    await storageService.saveTokens(token);
  }

  /// Inicializa cargando tokens del storage
  Future<bool> initialize() async {
    try {
      currentTokenInternal = await storageService.getTokens();

      if (currentTokenInternal == null) return false;

      if (currentTokenInternal!.needsRefresh &&
          currentTokenInternal!.isRefreshTokenValid) {
        await refreshToken();
      }

      return currentTokenInternal?.isAccessTokenValid ?? false;
    } catch (e) {
      debugPrint('Error inicializando: $e');
      await clearSession();
      return false;
    }
  }

  /// Refresca el token de acceso usando el refresh token
  Future<TokenModel> refreshToken() async {
    if (currentTokenInternal == null ||
        !currentTokenInternal!.isRefreshTokenValid) {
      await clearSession();
      throw SessionExpiredException();
    }

    try {
      final response = await dio.post(
        KeyclockConstants.tokenUrl,
        data: {
          'client_id': KeyclockConstants.clientId,
          if (KeyclockConstants.clientSecret != null)
            'client_secret': KeyclockConstants.clientSecret,
          'refresh_token': currentTokenInternal!.refreshToken,
          'grant_type': 'refresh_token',
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      currentTokenInternal = TokenModel.fromKeycloakResponse(response.data);
      await storageService.saveTokens(currentTokenInternal!);
      return currentTokenInternal!;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        await clearSession();
        throw SessionExpiredException();
      }
      throw handleDioError(e);
    }
  }

  /// Obtiene un access token válido, refrescando el token si es necesario
  Future<String> getValidAccessToken() async {
    if (currentTokenInternal == null) throw SessionExpiredException();

    if (currentTokenInternal!.isAccessTokenValid) {
      return currentTokenInternal!.accessToken;
    }

    if (currentTokenInternal!.isRefreshTokenValid) {
      await refreshToken();
      return currentTokenInternal!.accessToken;
    }

    await clearSession();
    throw SessionExpiredException();
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    if (currentTokenInternal != null) {
      try {
        // Intentamos revocar el token en el servidor
        await dio.post(
          KeyclockConstants.logoutUrl,
          data: {
            'client_id': KeyclockConstants.clientId,
            if (KeyclockConstants.clientSecret != null)
              'client_secret': KeyclockConstants.clientSecret,
            'refresh_token': currentTokenInternal!.refreshToken,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );
      } catch (e) {
        debugPrint('Error revocando token: $e');
      }
    }
    await clearSession();
  }

  /// Limpia la sesión actual, eliminando los tokens almacenados
  Future<void> clearSession() async {
    currentTokenInternal = null;
    await storageService.clearAllAuthData();
  }

  /// Obtiene la información del usuario desde el token actual (sin validar expiración)
  /// Para obtener info actualizada del servidor, usar getValidAccessToken() primero
  Map<String, dynamic>? getUserInfo() {
    if (currentTokenInternal == null) return null;

    final result = JwtDecoder.decode(currentTokenInternal!.accessToken);

    return {
      'sub': result["sub"],
      'email': result['email'],
      'preferred_username': result['preferred_username'],
      'name': result['name'],
    };
  }

  ///Se le hace override en las clases hijas - se implementan
  /// Login con navegador (OAuth2/OIDC) - implementado por cada plataforma
  Future<void> loginWithBrowser();

  /// Maneja el callback de OAuth (principalmente para web)
  Future<bool> handleOAuthCallback();
}
