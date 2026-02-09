import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keycloack_integrations/src/data/model/user_model.dart';
import 'package:keycloack_integrations/src/presentation/login/bloc/auth_bloc/auth_bloc.dart';
import 'package:keycloack_integrations/src/presentation/main/layouts/main_mobile_layout.dart';
import 'package:keycloack_integrations/src/presentation/main/layouts/main_web_layout.dart';
import 'package:keycloack_integrations/src/router/di.dart';

class MainScreen extends StatelessWidget {
   MainScreen({super.key});
  final UserModel? user = getIt<AuthBloc>().tryGetUser();
  @override
  Widget build(BuildContext context) {
    return (kIsWeb) ? MainWebLayout(user: user!,) : MainMobileLayout(user: user!,);
  }
}
