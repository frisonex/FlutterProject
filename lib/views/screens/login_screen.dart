import 'package:asegensa/views/screens/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            showAuthActionSwitch: false,
            // desactiva el botón de registro
            providers: [
              EmailAuthProvider(),
              // GoogleProvider(clientId: "162266611818-sacvqc9nq2ar7dths62qrrq1fe8tf8b9.apps.googleusercontent.com"),  // new
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(aspectRatio: 1, child: Image.asset('assets/Difare-horizontal.png')),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('Bienvenido'));
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(80),
                child: AspectRatio(aspectRatio: 1, child: Image.asset('assets/Difare.png'), ),
              );
            },
          );
        }
        // return DespachoFechaScreen();
        return MenuScreen();
      },
    );
  }
}
