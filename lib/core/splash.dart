import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:market/core/wedge.dart';
import 'package:provider/provider.dart';

import '../aux/extra/theme_change.dart';
import '../aux/extra/user_details.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        backgroundColor: themeNotifier.isDark
            ? Theme.of(context).primaryColorDark
            : Colors.white,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: AnimatedSplashScreen(
                  backgroundColor: themeNotifier.isDark
                      ? Theme.of(context).primaryColorDark
                      : Colors.white,
                  splash: named(),
                  duration: 3000,
                  splashTransition: SplashTransition.fadeTransition,
                  nextScreen: const Wedge()),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "${CurrentUser().getUserName()}@keter",
                  ),
                )),
          ],
        ),
      );
    });
  }

  Padding named() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        "Mini-Market",
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
