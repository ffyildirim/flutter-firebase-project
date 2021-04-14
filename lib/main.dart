import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_app/UI/home_page.dart';
import 'package:meet_app/UI/sign_in_page.dart';
import 'package:meet_app/UI/splash_screen.dart';
import 'package:meet_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:meet_app/locator.dart';
import 'package:meet_app/models/user_model.dart';
import 'package:meet_app/repositories/user_repository.dart';

void main() {
  setUpLocator();
  runApp(MeetApp());
}

class MeetApp extends StatefulWidget {
  const MeetApp();
  @override
  _MeetAppState createState() => _MeetAppState();
}

class _MeetAppState extends State<MeetApp> {
  final _userRepository = locator<UserRepository>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MeetApp",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationBloc()..add(CheckAuthentication()),
          ),
        ],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationFailure) {
              return SignInPage();
            }
            if (state is AuthenticationSuccess) {
              UserModel user = state.userModel;
              _userRepository.handleDynamicLinksBackgroundMode(context, user);
              return StartingPage(user);
            }
            if (state is SignOutSuccess) {
              return SignInPage();
            }
            return SplashScreen();
          },
        ),
      ),
    );
  }
}
