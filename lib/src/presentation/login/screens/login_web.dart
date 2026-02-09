// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keycloack_integrations/src/config/theme/colors.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';

class LoginWeb extends StatelessWidget {
  const LoginWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > 1200;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), AppColor.primary, Color(0xFF1A3F7A)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Container()),
            Expanded(
              flex: isWideScreen ? 3 : 1,

              child: _buildLoginPanel(isWideScreen, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPanel(bool isWideScreen, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: isWideScreen
            ? const BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 60,
            offset: const Offset(-20, 0),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWideScreen ? 60 : 24,
            vertical: 40,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icono de bienvenida
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primary.withOpacity(0.1),
                        AppColor.celeste.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: AppColor.primary,
                  ),
                ),

                // Títulos
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Accede a tu cuenta corporativa de forma\nsegura con Keycloak',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                MouseRegion(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),

                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.read<AuthBloc>().add(
                            AuthEvent.loginPressed(),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColor.primary,
                                const Color(0xFF1A4A8C),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.key_rounded,
                                    color: AppColor.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Continuar con Keycloak',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColor.border, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Autenticación empresarial',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.grey.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColor.border, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Info card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.info.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.info.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColor.info.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColor.info,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Conexión Segura',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.info,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Encriptación de extremo a extremo',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColor.info.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Footer
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterChip(Icons.lock_rounded, 'SSL'),
                        const SizedBox(width: 16),
                        _buildFooterChip(Icons.verified_rounded, 'OAuth 2.0'),
                        const SizedBox(width: 16),
                        _buildFooterChip(Icons.fingerprint_rounded, 'MFA'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '© 2026.` Todos los derechos reservados.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.grey.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Política de Privacidad',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.primary.withOpacity(0.7),
                            ),
                          ),
                        ),
                        Text(
                          '•',
                          style: TextStyle(
                            color: AppColor.grey.withOpacity(0.4),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Términos de Uso',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.primary.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.grayLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColor.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
