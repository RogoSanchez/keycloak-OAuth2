import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/config/theme/app_sizedbox.dart';
import 'package:keycloack_integrations/src/data/model/user_model.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';
import 'package:keycloack_integrations/src/presentation/widgets/session_button.dart';

class MainMobileLayout extends StatelessWidget {
  MainMobileLayout({super.key, required this.user});

  final UserModel user;
  final fontSize = 12.sp;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Estas logueado en Android",
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Center(
              child: Text(
                "Usuario:${user.username}",
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Center(
              child: Text(
                "Id:${user.id}",
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Center(
              child: Text(
                "Correo:${user.email}",
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            AppSizeBox.v16,
            SizedBox(
              height: 0.05.sh,
              width: 0.70.sw,
              child: SessionButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    AuthEvent.authenticationLogoutPressed(),
                  );
                }, text: 'Cerrar sesión',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
