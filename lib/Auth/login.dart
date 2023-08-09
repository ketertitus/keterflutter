import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerCollection = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  String? error = "";
  bool islogin = true;
  bool isloading = false;
  Future<void> emailSignIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message;
        isloading = false;
      });
    }
  }

  Future<void> newUser() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          userName: _controllerName.text,
          bizzName: _controllerCollection.text,
          email: _controllerEmail.text,
          password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message;
        isloading = false;
      });
    }
  }

  String logTitle() => islogin ? "Log in..." : "Sign up...";
  String iLogTitle() => islogin ? "Sign up..." : "Log in...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome..."),
        actions: [logOrRegisterButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your email and password:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            islogin
                ? const SizedBox()
                : Column(
                    children: [
                      textControl(control: _controllerName, label: "Your Name"),
                      textControl(
                          control: _controllerCollection,
                          label: "Bussiness Name"),
                    ],
                  ),
            textControl(control: _controllerEmail, label: "Email"),
            textControl(control: _controllerPassword, label: "Password"),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: isloading ? loading() : errorMessage()),
            ),
            Align(alignment: Alignment.topRight, child: entryButton())
          ]),
        ),
      ),
    );
  }

  StreamBuilder<User?> loading() {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? const Text("")
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Authenticating..."),
                  ),
                ],
              );
      },
    );
  }

  Text errorMessage() {
    return Text(
      error ?? "_",
      style: const TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.red,
      ),
    );
  }

  TextButton logOrRegisterButton() {
    return TextButton(
      child: Text(iLogTitle()),
      onPressed: () {
        setState(() {
          islogin = !islogin;
        });
      },
    );
  }

  TextButton entryButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isloading = true;
          });
          islogin ? emailSignIn() : newUser();
        },
        child: Text(logTitle()));
  }

  TextField textControl(
      {required TextEditingController control, required String label}) {
    return TextField(
        controller: control,
        decoration: InputDecoration(
          label: Text(label),
        ));
  }
}
