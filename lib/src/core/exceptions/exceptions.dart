/// Excepciones personalizadas para Keycloak
class KeycloakException implements Exception {
  final String message;
  final String? errorCode;
  final dynamic originalError;

  KeycloakException(this.message, {this.errorCode, this.originalError});

  @override
  String toString() => 'KeycloakException: $message (code: $errorCode)';
}

class InvalidCredentialsException extends KeycloakException {
  InvalidCredentialsException([super.message = 'Credenciales inválidas'])
    : super(errorCode: 'invalid_credentials');
}

class TokenRefreshException extends KeycloakException {
  TokenRefreshException([super.message = 'Error al refrescar token'])
    : super(errorCode: 'token_refresh_failed');
}

class SessionExpiredException extends KeycloakException {
  SessionExpiredException([super.message = 'Sesión expirada'])
    : super(errorCode: 'session_expired');
}
