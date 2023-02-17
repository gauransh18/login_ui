import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_peeps/open_peeps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:developer' as devtools show log;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<String> gs() async {
  var url = Uri.parse('https://www.greetingsapi.com/random');

  var response = await http.get(url);

  var jsonResponse = jsonDecode(response.body);
  var greetingText = jsonResponse['greeting'];
  // print(greetingText);

  return greetingText;
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

class _HomePageState extends State<HomePage> {
  String greetingTextPrint = 'Loading...';

  @override
  void initState() {
    hehe2(); //idhar directly hehe() call krste hai vs usme return type void krdo or fir hehe2() ki koi zarurat nhi
    super.initState();
    // print("initState() called");

    //   Timer(Duration(seconds: 2), () {
    //     setState(() {
    //       hehe2();
    //     });
    //   });
    // }
  }

  // Future<void> hehe() async {
  //   Future<String> futureGreetingText = gs();
  //   greetingTextPrint = await futureGreetingText;

  //   print(greetingTextPrint);
  //   // return greetingTextPrint;
  // }

  Future<void> hehe() async {
    try {
      final response =
          await http.get(Uri.parse('https://www.greetingsapi.com/random'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final greetingText = jsonResponse['greeting'];
        setState(() {
          greetingTextPrint = greetingText;
          devtools.log(
              "Greeting text loaded: $greetingText, language: ${jsonResponse['language']}");
          //   print(greetingTextPrint);
        });
      } else {
        devtools.log("Failed to load greeting text: ${response.statusCode}");
        //  print('Failed to load greeting text: ${response.statusCode}');
        // print(greetingTextPrint);
      }
    } catch (e) {
      devtools.log("Failed to load greeting text: $e");
      // print('Failed to load greeting text: $e');
      //  print(greetingTextPrint);
    }
  }

  void hehe2() async {
    devtools.log("hehe2() called");
    //print("hehe2() called");
    await hehe();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, //Color.fromARGB(255, 196, 196, 196),
        body: SafeArea(
          child:
              // Column(
              //   children: [
              //     Container(
              //       alignment: Alignment.topRight,
              //       child: IconButton(
              //         onPressed: () {},
              //         icon: const Icon(Icons.info),
              //         alignment: Alignment.topRight,
              //       ),
              //     ),
              Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //avatar illustration
                avatarWidget,

                const SizedBox(height: 20),

                Text(
                  greetingTextPrint + "!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                //email text field
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 225, 225, 225),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Color.fromARGB(255, 160, 160, 160),
                      //     offset: Offset(2, 2),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      //   BoxShadow(
                      //     color: Color.fromARGB(255, 160, 160, 160),
                      //     offset: Offset(-4, -4),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      // ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "email/username",
                        ),
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
                      color: Color.fromARGB(255, 225, 225, 225),
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Color.fromARGB(255, 160, 160, 160),
                      //     offset: Offset(2, 2),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      //   BoxShadow(
                      //     color: Color.fromARGB(255, 160, 160, 160),
                      //     offset: Offset(-2, -2),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      // ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
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
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Color.fromARGB(255, 120, 120, 120),
                      //     offset: Offset(2, 2),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      //   BoxShadow(
                      //     color: Color.fromARGB(255, 176, 176, 176),
                      //     offset: Offset(-2, -2),
                      //     blurRadius: 10.0,
                      //     spreadRadius: 1.0,
                      //   ),
                      // ],
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // ],
          //   ),
        ));
  }
}
