import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/config/theme/app_sizedbox.dart';
import 'package:keycloack_integrations/src/data/model/user_model.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';
import 'package:keycloack_integrations/src/presentation/widgets/session_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebProfile(context) : _buildMobileProfile(context);
  }

  Widget _buildMobileProfile(BuildContext context) {
    final fontSize = 12.sp;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            children: [
              CircleAvatar(
                radius: 48.r,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  user.username.isNotEmpty
                      ? user.username[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AppSizeBox.v16,
              Text(
                user.username,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSizeBox.v8,
              if (user.email != null)
                Text(
                  user.email!,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.grey[600],
                  ),
                ),
              AppSizeBox.v16,
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _infoTile(
                        icon: Icons.person_outline,
                        label: 'Usuario',
                        value: user.username,
                        fontSize: fontSize,
                      ),
                      Divider(height: 24.h),
                      _infoTile(
                        icon: Icons.fingerprint,
                        label: 'ID',
                        value: user.id,
                        fontSize: fontSize,
                      ),
                      if (user.email != null) ...[
                        Divider(height: 24.h),
                        _infoTile(
                          icon: Icons.email_outlined,
                          label: 'Correo',
                          value: user.email!,
                          fontSize: fontSize,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                height: 0.06.sh,
                width: 0.70.sw,
                child: SessionButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthEvent.authenticationLogoutPressed(),
                        );
                  },
                  text: 'Cerrar sesión',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebProfile(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (user.email != null)
                  Text(
                    user.email!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _infoTile(
                          icon: Icons.person_outline,
                          label: 'Usuario',
                          value: user.username,
                          fontSize: 16,
                        ),
                        const Divider(height: 24),
                        _infoTile(
                          icon: Icons.fingerprint,
                          label: 'ID',
                          value: user.id,
                          fontSize: 16,
                        ),
                        if (user.email != null) ...[
                          const Divider(height: 24),
                          _infoTile(
                            icon: Icons.email_outlined,
                            label: 'Correo',
                            value: user.email!,
                            fontSize: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 56,
                  width: 220,
                  child: SessionButton(
                    textSize: 4.sp,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            AuthEvent.authenticationLogoutPressed(),
                          );
                    },
                    text: 'Cerrar sesión',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required double fontSize,
  }) {
    return Row(
      children: [
        Icon(icon, size: fontSize + 8, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize - 2,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
