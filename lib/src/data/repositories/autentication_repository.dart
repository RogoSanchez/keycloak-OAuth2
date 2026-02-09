import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:keycloack_integrations/src/core/exceptions/exceptions.dart';
import 'package:keycloack_integrations/src/core/services/abstract_service.dart';
import 'package:keycloack_integrations/src/entities/model/token_model.dart';
import 'package:keycloack_integrations/src/entities/model/user_model.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  sessionExpired,
}

/// Repositorio de autenticación que actúa como capa de abstracción sobre el KeycloakService
class AuthenticationRepository {
  final AbstractKeycloakService _keycloakService;

  final _controller = StreamController<AuthenticationStatus>.broadcast();
  AuthenticationStatus _currentStatus = AuthenticationStatus.unknown;
  UserModel? _currentUser;

  AuthenticationRepository({required AbstractKeycloakService keycloakService})
    : _keycloakService = keycloakService;

  AuthenticationStatus get currentStatus => _currentStatus;

  UserModel? get currentUser => _currentUser;

  TokenModel? get currentTokens => _keycloakService.currentToken;

  /// Stream de cambios en el estado de autenticación
  Stream<AuthenticationStatus> get status async* {
    yield _currentStatus;
    await for (final status in _controller.stream) {
      _currentStatus = status;
      yield status;
    }
  }

  /// Inicializa el repositorio verificando si hay una sesión activa
  Future<void> initialize() async {
    try {
      // Primero intentamos capturar el callback de OAuth (solo web)
      if (kIsWeb) {
        final handledCallback = await _keycloakService.handleOAuthCallback();
        if (handledCallback) {
          _loadUserFromToken();
          _updateStatus(AuthenticationStatus.authenticated);
          return;
        }
      }

      // Si no hay callback, verificamos sesión existente
      final hasValidSession = await _keycloakService.initialize();

      if (hasValidSession) {
        _loadUserFromToken();
        _updateStatus(AuthenticationStatus.authenticated);
      } else {
        _updateStatus(AuthenticationStatus.unauthenticated);
      }
    } catch (e) {
      debugPrint('Error inicializando AuthRepository: $e');
      _updateStatus(AuthenticationStatus.unauthenticated);
    }
  }

  /// Login usando el navegador (OAuth2/OIDC)
  Future<UserModel?> logInWithBrowser() async {
    try {
      await _keycloakService.loginWithBrowser();
      _loadUserFromToken();
      _updateStatus(AuthenticationStatus.authenticated);
      return _currentUser;
    } on KeycloakException catch (e) {
      _updateStatus(AuthenticationStatus.unauthenticated);
      throw Exception(e.message);
    } catch (e) {
      _updateStatus(AuthenticationStatus.unauthenticated);
      throw Exception('Error de autenticación: $e');
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logOut() async {
    try {
      await _keycloakService.logout();
    } catch (e) {
      debugPrint('Error en logout: $e');
    } finally {
      _currentUser = null;
      _updateStatus(AuthenticationStatus.unauthenticated);
    }
  }

  /// Automáticamente refresca el token si está expirado
  Future<String> getAccessToken() async {
    try {
      return await _keycloakService.getValidAccessToken();
    } on SessionExpiredException {
      _updateStatus(AuthenticationStatus.sessionExpired);
      rethrow;
    }
  }

  /// Refresca manualmente el token de acceso
  Future<void> refreshSession() async {
    try {
      await _keycloakService.refreshToken();
      _loadUserFromToken();
    } on SessionExpiredException {
      _currentUser = null;
      _updateStatus(AuthenticationStatus.sessionExpired);
      rethrow;
    }
  }

  /// Obtiene el usuario actual
  UserModel? getCurrentUser() {
    if (_currentUser != null) return _currentUser;

    if (_keycloakService.currentToken != null) {
      _loadUserFromToken();
    }

    return _currentUser;
  }

  /// Verifica si el usuario tiene un rol del realm
  bool hasRealmRole(String role) {
    return _keycloakService.currentToken?.hasRealmRole(role) ?? false;
  }

  /// Verifica si el usuario tiene un rol de un cliente específico
  bool hasClientRole(String clientId, String role) {
    return _keycloakService.currentToken?.hasClientRole(clientId, role) ??
        false;
  }

  /// Obtiene todos los roles del realm del usuario
  List<String> get realmRoles {
    return _keycloakService.currentToken?.realmRoles ?? [];
  }

  void _updateStatus(AuthenticationStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _controller.add(status);
    }
  }

  void _loadUserFromToken() {
    final map = _keycloakService.getUserInfo();
    if (map != null) {
      _currentUser = UserModel.fromMap(map);
    }
  }

  /// Libera recursos
  void dispose() {
    _controller.close();
  }
}
