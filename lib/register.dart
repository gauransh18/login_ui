// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_peeps/open_peeps.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:developer' as devtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_ui/utilities/show_error_dialog.dart';
import 'package:login_ui/constants/routes.dart';
import 'package:login_ui/services/auth/auth_service.dart';

class Greeting {
  final String language;
  final String message;

  Greeting({required this.language, required this.message});

  factory Greeting.fromJson(Map<String, dynamic> json) {
    return Greeting(
      language: json['language'],
      message: json['message'],
    );
  }
}

class registerView extends StatefulWidget {
  const registerView({Key? key}) : super(key: key);

  @override
  State<registerView> createState() => _registerViewState();
}

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

class _registerViewState extends State<registerView> {
  String greetingTextPrint = 'Hello!';
  String greetingTextLanguage = 'English';
  List<Greeting> greetings = [];

  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _obscurePassword = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    hehe();
    super.initState();
  }

  //get greeting text
  Future<void> hehe() async {
    final response = await http.get(Uri.parse(
        'https://gauransh18.github.io/login_ui/assets/greetings.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['greetings'];
      setState(() {
        greetings = data.map((json) => Greeting.fromJson(json)).toList();
        greetingTextPrint = getRandomGreeting();
      });
    }
  }

  String getRandomGreeting() {
    final random = Random();
    final randomIndex = random.nextInt(greetings.length);
    setState(() {
      greetingTextLanguage = greetings[randomIndex].language;
    });
    return greetings[randomIndex].message;
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
          title: const Text("Email Verification Required"),
          content: const Text(
            "We've sent you an email verification. Please open it to verify your accout.\nIf you haven't received a verification email yet, press the button below to resend.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text(
                'Continue',
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
                      splashRadius: 0.5,
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
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 117, 117, 117),
                            )),
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
                      child: TextFormField(
                        controller: _password,
                        obscureText: _obscurePassword,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 117, 117, 117),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
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
                        devtools.log("Register button pressed");
                        final email = _email.text;
                        final password = _password.text;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();
                          // ignore: use_build_context_synchronously
                          verificationDialog(context);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Navigator.pop(context);
                            await showErrorDialog(
                              context,
                              "Weak password",
                            );
                          } else if (e.code == 'email-already-in-use') {
                            Navigator.pop(context);
                            await showErrorDialog(
                              context,
                              "Email is already in use",
                            );
                          } else if (e.code == 'invalid-email') {
                            Navigator.pop(context);
                            await showErrorDialog(
                              context,
                              "Invalid email",
                            );
                          } else {
                            Navigator.pop(context);
                            await showErrorDialog(
                              context,
                              "Error: ${e.code}",
                            );
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          await showErrorDialog(
                            context,
                            e.toString(),
                          );
                        }
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute,
                            (route) => false,
                          );
                        },
                        child: const Text("Login")),
                  ],
                ),

                //or continue with using divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text("Or continue with",
                        style: TextStyle(
                          color: Color.fromARGB(255, 87, 87, 87),
                        )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),

                const SizedBox(height: 20),

                //google login button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: GestureDetector(
                            onTap: () =>
                                AuthService2().signINWtihGoogle(context).then(
                                  (value) {
                                    if (value != null) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        finalRoute,
                                        (_) => false,
                                      );
                                    }
                                  },
                                ),
                            child: Image.asset('assets/google.png',
                                height: 40.0))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
