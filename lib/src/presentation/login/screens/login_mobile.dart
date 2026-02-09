// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/data/repositories/autentication_repository.dart';
import 'package:keycloack_integrations/src/presentation/widgets/session_button.dart';
import 'package:keycloack_integrations/src/router/di.dart';
import 'package:keycloack_integrations/src/config/theme/colors.dart';

class LoginMobile extends StatelessWidget {
  const LoginMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primary, Color(0xFF1A3F7A), Color(0xFF0A1F3D)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    _buildLogo(),
                    SizedBox(height: 40.h),
                    _buildLoginCard(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColor.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.celeste.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 48.sp,
            color: AppColor.white,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Inicia sesión para continuar',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.white.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Usa tu cuenta corporativa para acceder',
            style: TextStyle(fontSize: 13.sp, color: AppColor.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),

          // Botón de Keycloak
          SessionButton(
            onPressed: _handleKeycloakLogin,
            text: 'Continuar con Keycloak',
          ),

          SizedBox(height: 20.h),

          // Divider con texto
          Row(
            children: [
              Expanded(child: Divider(color: AppColor.border, thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Autenticación segura',
                  style: TextStyle(fontSize: 12.sp, color: AppColor.grey),
                ),
              ),
              Expanded(child: Divider(color: AppColor.border, thickness: 1)),
            ],
          ),

          SizedBox(height: 20.h),

          // Info de seguridad
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColor.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColor.info.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: AppColor.info, size: 24.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Tu información está protegida con encriptación de extremo a extremo',
                    style: TextStyle(fontSize: 12.sp, color: AppColor.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleKeycloakLogin() async {
    try {
      await getIt<AuthenticationRepository>().logInWithBrowser();
    } catch (e) {
      debugPrint('Error en login: $e');
      rethrow;
    }
  }
}
