import 'dart:async';
import 'package:keycloack_integrations/src/core/constants/keyclock_constants.dart';
import 'package:keycloack_integrations/src/core/services/abstract_service.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:keycloack_integrations/src/core/exceptions/exceptions.dart';
import 'package:keycloack_integrations/src/data/model/token_model.dart';

/// Servicio Android para la integración con Keycloak
///
/// Proporciona métodos para:
/// - Login con OAuth2/OIDC (Authorization Code Grant con PKCE) desde Android
class KeycloakServiceAndroid extends AbstractKeycloakService {
  final FlutterAppAuth _appAuth;

  KeycloakServiceAndroid({
    required super.dio,
    required super.storageService,
    required FlutterAppAuth appAuth,
  }) : _appAuth = appAuth;

  /// Login usando AppAuth - abre el navegador y hace todo el flujo OAuth2
  /// Este es el método recomendado para Android
  @override
  Future<TokenModel> loginWithBrowser() async {
    try {

      // Configuración manual para permitir HTTP en desarrollo
      // En producción usar discoveryUrl con HTTPS
      //   final serviceConfiguration = AuthorizationServiceConfiguration(
      //   authorizationEndpoint: KeyclockConstants.authorizationUrl,
      //   tokenEndpoint: KeyclockConstants.tokenUrl,
      //   endSessionEndpoint: KeyclockConstants.logoutUrl,
      // );

      final AuthorizationTokenResponse result = await _appAuth
          .authorizeAndExchangeCode(
            AuthorizationTokenRequest(
              KeyclockConstants.clientId,
              KeyclockConstants.redirectUri,
              // serviceConfiguration: serviceConfiguration,
              discoveryUrl: KeyclockConstants.discoveryUrl,
              scopes: KeyclockConstants.scopes,
              promptValues: ['login'],
              allowInsecureConnections: true,
              
            ),
          );

      final token = TokenModel(
        accessToken: result.accessToken!,
        refreshToken: result.refreshToken!,
        idToken: result.idToken,
        accessTokenExpiry: result.accessTokenExpirationDateTime!,
        scopes: result.scopes ?? KeyclockConstants.scopes,
        tokenType: result.tokenType ?? 'Bearer',
      );

      await saveToken(token);
      return token;
    } on FlutterAppAuthUserCancelledException {
      throw KeycloakException('Autenticación cancelada por el usuario');
    } catch (e) {
      if (e is KeycloakException) rethrow;
      throw KeycloakException(
        'Error en autenticación OAuth2: $e',
        originalError: e,
      );
    }
  }

  //Implementado solo en web
  @override
  Future<bool> handleOAuthCallback() {
    throw UnimplementedError();
  }
}
