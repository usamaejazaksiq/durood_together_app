import 'package:durood_together_app/Screens/HomeTabs/home_tab_controls.dart';
import 'package:durood_together_app/Screens/Login/login_screen.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginDecider extends StatelessWidget {
  const LoginDecider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Expanded(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went Wrong!'));
            } else if (snapshot.hasData && snapshot.data != null) {
              return const MyHomeTabs();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
