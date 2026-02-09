// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keycloack_integrations/src/data/repositories/autentication_repository.dart';
import 'package:keycloack_integrations/src/presentation/login/screens/login_mobile.dart';
import 'package:keycloack_integrations/src/presentation/login/screens/login_web.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.authenticationRepository});

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return LoginWeb();
    } else {
      return LoginMobile();
    }
  }
}
