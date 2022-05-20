import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keep/config/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), _navigationPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset('assets/icons/keep.png'),
          Text('KEEP NOTES', style: Theme.of(context).textTheme.titleLarge)
        ]),
      ),
    );
  }

  void _navigationPage() {
    var route = Routes.login;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      route = Routes.home;
    }

    Navigator.pushReplacementNamed(context, route);
  }
}
