// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

enum MenuAction { logout }

class FinalS extends StatefulWidget {
  const FinalS({super.key});

  @override
  State<FinalS> createState() => _FinalSState();
}

class _FinalSState extends State<FinalS> {
  final _controller = ConfettiController(duration: const Duration(seconds: 5));

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Select an option'),
            //content: const Text("Select an option"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  _controller.play();
                },
                child: const Text('Celebrate Again'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                },
                child: const Text("Log out"),
              ),
            ],
          );
        }).then((value) => value ?? false);
  }

  @override
  void initState() {
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                showLogOutDialog(context);
              },
              child: const Text("Click me"),
            ),
          ),
        ),

        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Container(
        //     alignment: Alignment.center,
        //     child: TextButton(
        //       onPressed: () {
        //         showLogOutDialog(context);
        //       },
        //       child: const Text("Log out"),
        //     ),
        //   ),
        // ),

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Align(
        //       alignment: Alignment.center,
        //       child: Container(
        //         alignment: Alignment.center,
        //         child: TextButton(
        //           onPressed: () {
        //             _controller.play();
        //           },
        //           child: const Text("Celebrate again"),
        //         ),
        //       ),
        //     ),
        //     Align(
        //       alignment: Alignment.center,
        //       child: Container(
        //         alignment: Alignment.center,
        //         child: TextButton(
        //           onPressed: () {
        //             showLogOutDialog(context);
        //           },
        //           child: const Text("Log out"),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    ));
  }
}
