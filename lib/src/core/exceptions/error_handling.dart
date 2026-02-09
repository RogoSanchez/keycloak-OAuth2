import 'package:dio/dio.dart';
import 'package:keycloack_integrations/src/core/exceptions/exceptions.dart';

KeycloakException handleDioError(DioException e) {
    final responseData = e.response?.data;
    String? errorDescription;
    String? errorCode;

    if (responseData is Map) {
      errorDescription = responseData['error_description'] as String?;
      errorCode = responseData['error'] as String?;
    }

    switch (e.response?.statusCode) {
      case 400:
        if (errorCode == 'invalid_grant') {
          return InvalidCredentialsException(
            errorDescription ?? 'Usuario o contraseña incorrectos',
          );
        }
        return KeycloakException(
          errorDescription ?? 'Solicitud inválida',
          errorCode: errorCode,
        );
      case 401:
        return InvalidCredentialsException(errorDescription ?? 'No autorizado');
      case 403:
        return KeycloakException(
          errorDescription ?? 'Acceso denegado',
          errorCode: 'forbidden',
        );
      case null:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return KeycloakException(
            'Tiempo de espera agotado',
            errorCode: 'timeout',
          );
        }
        if (e.type == DioExceptionType.connectionError) {
          return KeycloakException(
            'Error de conexión. Verifica tu conexión a internet.',
            errorCode: 'connection_error',
          );
        }
        return KeycloakException(
          'Error de red: ${e.message}',
          errorCode: 'network_error',
        );
      default:
        return KeycloakException(
          errorDescription ?? 'Error del servidor',
          errorCode: errorCode ?? 'server_error',
        );
    }
  }

