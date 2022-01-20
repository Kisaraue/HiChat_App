import 'package:flutter/material.dart';
import 'package:hichat/theme.dart';
import 'package:hichat/ui/screens/onboarding/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiChat',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: Onboarding(),
    );
  }
}
