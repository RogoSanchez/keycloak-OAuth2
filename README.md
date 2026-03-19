# Keycloak Integrations in Flutter

Example project to integrate OAuth2/OpenID Connect authentication with Keycloak in Flutter (Web and Android), including token management, session persistence, and protected navigation.

## What this project includes

- Login with Keycloak
- Multiplatform support:
	- Web: OAuth2 flow with redirect and callback
	- Android: flow with `flutter_appauth`
- Token persistence in secure/local storage
- Automatic token refresh when needed
- Authentication state management with BLoC
- Protected routes with `go_router`
- Initial loading screen to validate session

## Tech stack

- Flutter
- `flutter_bloc` / `bloc`
- `go_router`
- `dio`
- `flutter_appauth`
- `flutter_secure_storage`
- `shared_preferences`
- `get_it`
- `flutter_dotenv`

## Requirements

- Flutter SDK `^3.10.0`
- Dart compatible with the project SDK
- Running Keycloak instance
- OAuth2 client configured in Keycloak

## Quick setup

### 1. Clone and install dependencies

```bash
git clone https://github.com/RogoSanchez/keycloak-OAuth2.git
cd keycloack_integrations
flutter pub get
```

### 2. Create `.env` file

In the project root, create a `.env` file with these variables:

```env
KEYCLOAK_URL=http://localhost:8080
REALM=your_realm
CLIENT_ID=your_client_id
```

These variables are used by `KeyclockConstants` to build:

- `authorizationUrl`
- `tokenUrl`
- `logoutUrl`
- `userinfo`
- `discoveryUrl`

### 3. Configure redirect URIs in Keycloak

According to the current implementation:

- Web callback: `http://localhost:3000/callback`
- Android callback: `com.flutter.app://callback`

You must register these URIs in the Keycloak client, along with the necessary `Web Origins`.

## How to run

### Web

```bash
flutter run -d chrome --web-port=3000
```

### Android

```bash
flutter run
```

## Authentication flow

1. The app starts and loads `.env`
2. Dependencies are registered with `get_it`
3. `AuthBloc` triggers session initialization
4. Router evaluates state:
	 - `unknown` -> loading screen
	 - `authenticated` -> `/main`
	 - `unauthenticated` -> `/login`
5. On login, Keycloak is opened:
	 - Web: redirect to authorization endpoint
	 - Android: `authorizeAndExchangeCode` with AppAuth
6. Tokens are saved and global state is updated

## Useful structure to find your way

```text
lib/
	main.dart
	src/
		core/
			constants/keyclock_constants.dart
			services/
				abstract_service.dart
				keyclock_service_web.dart
				keyclock_service_android.dart
			storage/storage.dart
		data/
			repositories/autentication_repository.dart
			model/
		presentation/
			login/
			home/
			loading/
		router/
			app_router.dart
			di.dart
```

## Important notes

- The project uses `usesCleartextTraffic=true` on Android to facilitate local HTTP development.
- For production, HTTPS in Keycloak and hardened security settings are recommended.
- Configured scopes: `openid`, `profile`, `email`.

## Common issues

### Login redirects but does not enter the app

- Check that the `redirect_uri` configured in Keycloak matches exactly the one used by the app.
- Make sure `KEYCLOAK_URL`, `REALM`, and `CLIENT_ID` are correct.

### Web callback error

- Run the app on the expected port (`3000`) or adjust the callback URI and its configuration in Keycloak.

### Token expired

- The project tries automatic refresh.
- If the refresh token is no longer valid, the session is cleared and set to unauthenticated.

## Recommended next improvements

- Add `offline_access` if you need long sessions.
- Parameterize redirect URIs by environment (dev/stage/prod).
- Add integration tests for the login flow.


# Keycloak Integrations en Flutter

Proyecto de ejemplo para integrar autenticacion OAuth2/OpenID Connect con Keycloak en Flutter (Web y Android), con manejo de tokens, persistencia de sesion y navegacion protegida.

## Que incluye este proyecto

- Login con Keycloak
- Soporte multiplataforma:
	- Web: flujo OAuth2 con redireccion y callback
	- Android: flujo con `flutter_appauth`
- Persistencia de tokens en storage seguro/local
- Refresh automatico de token cuando corresponde
- Manejo de estado de autenticacion con BLoC
- Rutas protegidas con `go_router`
- Pantalla de carga inicial para validar sesion

## Stack tecnologico

- Flutter
- `flutter_bloc` / `bloc`
- `go_router`
- `dio`
- `flutter_appauth`
- `flutter_secure_storage`
- `shared_preferences`
- `get_it`
- `flutter_dotenv`

## Requisitos

- Flutter SDK `^3.10.0`
- Dart compatible con el SDK del proyecto
- Instancia de Keycloak funcionando
- Cliente OAuth2 configurado en Keycloak

## Configuracion rapida

### 1. Clonar e instalar dependencias

```bash
git clone https://github.com/RogoSanchez/keycloak-OAuth2.git
cd keycloack_integrations
flutter pub get
```

### 2. Crear archivo `.env`

En la raiz del proyecto crea un archivo `.env` con estas variables:

```env
KEYCLOAK_URL=http://localhost:8080
REALM=tu_realm
CLIENT_ID=tu_client_id
```

Estas variables se usan desde `KeyclockConstants` para construir:

- `authorizationUrl`
- `tokenUrl`
- `logoutUrl`
- `userinfo`
- `discoveryUrl`

### 3. Configurar redirect URIs en Keycloak

Segun la implementacion actual del proyecto:

- Web callback: `http://localhost:3000/callback`
- Android callback: `com.flutter.app://callback`

Debes registrar esas URIs en el cliente de Keycloak, junto con los `Web Origins` necesarios.

## Como ejecutar

### Web

```bash
flutter run -d chrome --web-port=3000
```

### Android

```bash
flutter run
```

## Flujo de autenticacion

1. La app inicia y carga `.env`
2. Se registran dependencias con `get_it`
3. `AuthBloc` dispara inicializacion de sesion
4. Router evalua estado:
	 - `unknown` -> pantalla de loading
	 - `authenticated` -> `/main`
	 - `unauthenticated` -> `/login`
5. En login se abre Keycloak:
	 - Web: redireccion a endpoint de autorizacion
	 - Android: `authorizeAndExchangeCode` con AppAuth
6. Se guardan tokens y se actualiza estado global

## Estructura util para ubicarte

```text
lib/
	main.dart
	src/
		core/
			constants/keyclock_constants.dart
			services/
				abstract_service.dart
				keyclock_service_web.dart
				keyclock_service_android.dart
			storage/storage.dart
		data/
			repositories/autentication_repository.dart
			model/
		presentation/
			login/
			home/
			loading/
		router/
			app_router.dart
			di.dart
```

## Notas importantes

- El proyecto usa `usesCleartextTraffic=true` en Android para facilitar desarrollo con HTTP local.
- Para produccion, se recomienda HTTPS en Keycloak y endurecer configuraciones de seguridad.
- Los scopes configurados son: `openid`, `profile`, `email`.

## Problemas comunes

### El login redirige pero no entra a la app

- Verifica que `redirect_uri` configurado en Keycloak coincida exactamente con el usado por la app.
- Revisa que `KEYCLOAK_URL`, `REALM` y `CLIENT_ID` sean correctos.

### Error en callback web

- Ejecuta la app en el puerto esperado (`3000`) o ajusta la URI de callback y su configuracion en Keycloak.

### Token expiro

- El proyecto intenta refresh automatico.
- Si el refresh token ya no es valido, la sesion se limpia y pasa a no autenticado.

## Siguientes mejoras recomendadas

- Agregar `offline_access` si necesitas sesiones largas.
- Parametrizar redirect URIs por entorno (dev/stage/prod).
- Agregar pruebas de integracion para flujo de login.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
