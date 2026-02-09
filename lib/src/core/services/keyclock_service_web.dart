import 'dart:async';
import 'package:keycloack_integrations/src/core/constants/keyclock_constants.dart';
import 'package:keycloack_integrations/src/core/services/abstract_service.dart';

import 'html_stub.dart' if (dart.library.html) 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:keycloack_integrations/src/core/exceptions/error_handling.dart';
import 'package:keycloack_integrations/src/entities/model/token_model.dart';

/// Servicio principal para la integración con Keycloak
///
/// Proporciona métodos para:
/// - Login con usuario/contraseña (Resource Owner Password Grant)
/// - Login con OAuth2/OIDC (Authorization Code Grant con PKCE)
/// - Refresh de tokens
/// - Logout
/// - Obtención de información del usuario
class KeycloakServiceWeb extends AbstractKeycloakService {
  KeycloakServiceWeb({required super.dio, required super.storageService});

  @override
  Future<void> loginWithBrowser() async {
    final keycloakLoginUrl = Uri.parse(
      '${KeyclockConstants.authorizationUrl}'
      '?client_id=${KeyclockConstants.clientId}'
      '&redirect_uri=${Uri.encodeComponent(KeyclockConstants.redirectUri)}'
      '&response_type=code'
      '&scope=${KeyclockConstants.scopes.join(' ')}',
    );
    html.window.location.href = keycloakLoginUrl.toString();
  }

  @override
  Future<bool> handleOAuthCallback() async {
    final uri = Uri.base;
    final code = uri.queryParameters['code'];

    if (code == null) return false;

    try {
      final response = await super.dio.post(
        KeyclockConstants.tokenUrl,
        data: {
          "grant_type": "authorization_code",
          "client_id": KeyclockConstants.clientId,
          "code": code,
          "redirect_uri": KeyclockConstants.redirectUri,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      super.currentTokenInternal = TokenModel.fromKeycloakResponse(
        response.data,
      );

      if (super.currentToken != null) {
        await super.storageService.saveTokens(super.currentToken!);
      }

      // Limpiar la URL del código
      html.window.history.replaceState(null, '', '/');
      return true;
    } on DioException catch (e) {
      debugPrint('Error procesando OAuth callback: $e');
      throw handleDioError(e);
    }
  }
}
