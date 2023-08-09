import 'package:flutter/material.dart';
import 'package:market/Auth/login.dart';
import 'package:market/core/home.dart';

import '../Auth/auth.dart';

class Wedge extends StatefulWidget {
  const Wedge({super.key});

  @override
  State<Wedge> createState() => _WedgeState();
}

class _WedgeState extends State<Wedge> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        return snapshot.hasData ? Home() : const LogIn();
      },
    );
  }
}
