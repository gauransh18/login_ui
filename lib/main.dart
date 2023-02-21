import 'package:flutter/material.dart';
import 'homepage.dart';
import 'register.dart';
import 'mainScreen.dart';
import 'package:login_ui/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../fireabase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      title: 'login_ui',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DecideScreen(),
      routes: {
        loginRoute: (context) => const HomePage(),
        registerRoute: (context) => const registerView(),
        finalRoute: (context) => const FinalS(),
      }));
}

// class CheckUserStatus extends StatelessWidget {
//   const CheckUserStatus({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           final user = snapshot.data;
//           if (user == null) {
//             return const HomePage();
//           } else {
//             return const FinalS();
//           }
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     ));
//   }
// }

class DecideScreen extends StatelessWidget {
  const DecideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        //a question mark can really say a lot?
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
           // devtools.log(user.toString());
            if (user != null) {
              if (user.emailVerified) {
              //  devtools.log("Email is verified");
                return const FinalS();
              } else {
                return const HomePage();
              }
            } else {
              return const HomePage();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
