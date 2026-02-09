import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:keycloack_integrations/src/core/constants/keyclock_constants.dart';
import 'package:keycloack_integrations/src/core/services/abstract_service.dart';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:keycloack_integrations/src/core/exceptions/exceptions.dart';
import 'package:keycloack_integrations/src/entities/model/token_model.dart';

/// Servicio Android para la integración con Keycloak
///
/// Proporciona métodos para:
/// - Login con OAuth2/OIDC (Authorization Code Grant con PKCE) desde Android
class KeycloakServiceAndroid extends AbstractKeycloakService {

  final FlutterAppAuth _appAuth;
  // final DeepLinkManager _deepLinkManager = DeepLinkManager();

  // Completer para esperar el código de autorización
  // Completer<String>? _codeCompleter;

  KeycloakServiceAndroid({
    required super.dio,
    required super.storageService,
    required FlutterAppAuth appAuth,
  }) : _appAuth = appAuth;

  // /// Inicializa el listener de deep links para capturar el código de autorización
  // void initDeepLinkHandler() {
  //   _deepLinkManager.init(
  //     callback: (Uri uri) {
  //       _handleAuthCallback(uri);
  //     },
  //   );
  // }

  // /// Maneja el callback de Keycloak y extrae el código
  // void _handleAuthCallback(Uri uri) {
  //   // Verificar que es el callback de Keycloak
  //   if (uri.path == '/callback' || uri.host == 'callback') {
  //     final code = uri.queryParameters['code'];
  //     final error = uri.queryParameters['error'];

  //     if (error != null) {
  //       _codeCompleter?.completeError(
  //         KeycloakException('Error de autenticación: $error'),
  //       );
  //       return;
  //     }

  //     if (code != null &&
  //         _codeCompleter != null &&
  //  z       !_codeCompleter!.isCompleted) {
  //       _codeCompleter!.complete(code);
  //     }
  //   }
  // }

  // /// Intercambia el código de autorización por tokens
  // Future<TokenModel> exchangeCodeForTokens(String code) async {
  //   try {
  //     final response = await dio.post(
  //       kConstKeycloak.tokenUrl,
  //       data: {
  //         'grant_type': 'authorization_code',
  //         'client_id': kConstKeycloak.clientId,
  //         'code': code,
  //         'redirect_uri': kConstKeycloak.redirectUri,
  //       },
  //       options: Options(contentType: Headers.formUrlEncodedContentType),
  //     );

  //     final token = TokenModel.fromKeycloakResponse(response.data);
  //     await saveToken(token);
  //     return token;
  //   } on DioException catch (e) {
  //     throw handleDioError(e);
  //   }
  // }

  // /// Login completo: espera el código del deep link y lo intercambia por tokens
  // Future<TokenModel> loginWithDeepLink() async {
  //   _codeCompleter = Completer<String>();

  //   try {
  //     // Esperar a que llegue el código via deep link
  //     final code = await _codeCompleter!.future.timeout(
  //       const Duration(minutes: 5),
  //       onTimeout: () =>
  //           throw KeycloakException('Timeout esperando autenticación'),
  //     );

  //     // Intercambiar código por tokens
  //     return await exchangeCodeForTokens(code);
  //   } finally {
  //     _codeCompleter = null;
  //   }
  // }

  // /// Libera recursos del deep link manager
  // void dispose() {
  //   _deepLinkManager.dispose();
  // }

  /// Login usando AppAuth - abre el navegador y hace todo el flujo OAuth2
  /// Este es el método recomendado para Android
  @override
  Future<TokenModel> loginWithBrowser() async {
    try {
      final AuthorizationTokenResponse result;
      if (kDebugMode) {
        // Configuración manual para permitir HTTP en desarrollo
        // En producción usar discoveryUrl con HTTPS
        final serviceConfiguration = AuthorizationServiceConfiguration(
          authorizationEndpoint: KeyclockConstants.authorizationUrl,
          tokenEndpoint: KeyclockConstants.tokenUrl,
          endSessionEndpoint: KeyclockConstants.logoutUrl,
        );

        result = await _appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            KeyclockConstants.clientId,
            KeyclockConstants.redirectUri,
            serviceConfiguration: serviceConfiguration,
            scopes: KeyclockConstants.scopes,
            promptValues: ['login'],
            allowInsecureConnections: true,
          ),
        );
      } else {
        result = await _appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            KeyclockConstants.clientId,
            KeyclockConstants.redirectUri,
            discoveryUrl: KeyclockConstants.discoveryUrl,
            scopes: KeyclockConstants.scopes,
            promptValues: ['login'],
            allowInsecureConnections: true,
          ),
        );
      }

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

  /// Solo abre el navegador para autorización (sin intercambiar el código)
  /// Útil si quieres manejar el código manualmente con deep links
  Future<void> openAuthorizationUrl() async {
    try {
      await _appAuth.authorize(
        AuthorizationRequest(
          KeyclockConstants.clientId,
          KeyclockConstants.redirectUri,
          discoveryUrl: KeyclockConstants.discoveryUrl,
          scopes: KeyclockConstants.scopes,
          promptValues: ['login'],
        ),
      );
    } catch (e) {
      throw KeycloakException(
        'Error abriendo URL de autorización: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> handleOAuthCallback() {
    throw UnimplementedError();
  }
}
