import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market/Auth/auth.dart';
import 'package:market/aux/extra/user_details.dart';
import 'package:market/aux/screens/inventory.dart';
import 'package:provider/provider.dart';

import '../aux/extra/theme_change.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  String userName = "default";

  @override
  void initState() {
    super.initState();
    bizzName();
  }

  bizzName() async {
    userName = await CurrentUser().getBizzName();
    setState(() {
      userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            actions: [popUp(themeNotifier)],
            title: Text(userName),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Divider(),
                  toInventory(context),
                  const Divider(),
                  makeSale(context),
                  const Divider(),
                ],
              ),
            ),
          ));
    });
  }

  PopupMenuButton<dynamic> popUp(ModelTheme themeNotifier) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: const Text('Log out'),
          onTap: () => signOut(),
        ),
        PopupMenuItem(
            child: Text(themeNotifier.isDark ? "Light Mode" : "Dark Mode"),
            onTap: () {
              themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
            }),
      ],
    );
  }

  ListTile toInventory(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Inventory(
                        isSaleInput: false,
                      )));
        },
        title: const Text("Inventory"));
  }

  ListTile makeSale(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Inventory(
                        isSaleInput: true,
                      )));
        },
        title: const Text("Sales Terminal"));
  }
}
