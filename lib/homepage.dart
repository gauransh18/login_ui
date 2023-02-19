// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_peeps/open_peeps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer' as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_ui/utilities/show_error_dialog.dart';
import '../constants/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//random illustration generator
final randomPeep = PeepGenerator().generate(
  // head: Head.atoms.first,
  // face: Face.atoms[3],
  facialHair: FacialHair.atoms.first,
  // accessory: Accessories.atoms.first,
);

final avatarWidget = PeepAvatar.fromPeep(
  size: 192,
  peep: randomPeep,
  backgroundColor: const Color.fromARGB(255, 79, 158, 255),
);

class _HomePageState extends State<HomePage> {
  String greetingTextPrint = 'Loading...';
  String greetingTextLanguage = 'Loading...';

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    hehe();
    super.initState();
  }

  //get greeting text from www.greeetingsapi.com/random
  Future<void> hehe() async {
    try {
      final response =
          await http.get(Uri.parse('https://www.greetingsapi.com/random'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final greetingText = jsonResponse['greeting'];
        setState(() {
          greetingTextPrint = greetingText;
          greetingTextLanguage = jsonResponse['language'];
          devtools.log(
              "Greeting text loaded: $greetingText, language: ${jsonResponse['language']}");
        });
      } else {
        devtools.log("Failed to load greeting text: ${response.statusCode}");
      }
    } catch (e) {
      devtools.log("Failed to load greeting text: $e");
    }
  }

  //return the greeting text language as string
  String hehe2() {
    String heheInfo =
        '$greetingTextPrint is a greeting in $greetingTextLanguage language.';
    return heheInfo;
  }

  //dialog box for the info button
  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Information"),
          content: Text(hehe2()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void verificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Email Verification Required"),
          content: Text(
            "We've sent you an email verification. Please open it to verify your accout.\nIf you haven't received a verification email yet, press the button below to resend.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                },
                child: const Text(
                  'Resend',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                )),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, //Color.fromARGB(255, 196, 196, 196),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  //avatar illustration
                  avatarWidget,

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 48),
                      Text(
                        greetingTextPrint,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSans(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showInfoDialog(context);
                        },
                        padding: const EdgeInsets.all(0.0),
                        alignment: Alignment.topLeft,
                        icon: const Icon(Icons.info),
                        splashRadius: 0.1,
                        iconSize: 15.0,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //email text field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 225, 225, 225),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          //controller: _email,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "email/username",
                          ),
                          controller: _email,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //password text field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 225, 225, 225),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "password",
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //login button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 79, 158, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          devtools.log("Login button pressed");

                          final email = _email.text;
                          final password = _password.text;

                          try {
                            final userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            devtools.log(userCredential.toString());
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              if (user.emailVerified) {
                                devtools.log("User is verified");
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  finalRoute,
                                  (_) => false,
                                );
                              } else {
                                devtools.log("User is not verified");
                                verificationDialog(context);
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              await showErrorDialog(
                                context,
                                "User not found",
                              );
                            } else if (e.code == 'wrong-password') {
                              await showErrorDialog(
                                context,
                                "Wrong password",
                              );
                            } else if (e.code == 'too-many-requests') {
                              await showErrorDialog(
                                context,
                                "Too many attempts.\nPlease try again after sometime",
                              );
                            } else {
                              await showErrorDialog(
                                context,
                                "Error: ${e.code}",
                              );
                            }
                          } catch (e) {
                            await showErrorDialog(
                              context,
                              e.toString(),
                            );
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //register text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            registerRoute,
                          );
                        },
                        child: const Text(
                          "Register here",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // ],
          //   ),
        ));
  }
}
