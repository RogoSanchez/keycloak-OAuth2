import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/config/theme/app_sizedbox.dart';
import 'package:keycloack_integrations/src/data/model/user_model.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';
import 'package:keycloack_integrations/src/presentation/widgets/session_button.dart';

class MainWebLayout extends StatelessWidget {
  const MainWebLayout({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    return Scaffold(
      body: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Estas logueado en web",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Center(
              child: Text(
                "Usuario:${user.username}",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Center(
              child: Text("Id:${user.id}", style: TextStyle(fontSize: 25)),
            ),
            Center(
              child: Text(
                "Correo:${user.email}",
                style: TextStyle(fontSize: 25),
              ),
            ),
            AppSizeBox.v16,
            SizedBox(
              height: 0.06.sh,
              width: 0.12.sw,
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
    );
  }
}
