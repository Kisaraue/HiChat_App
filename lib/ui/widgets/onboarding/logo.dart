import 'package:flutter/material.dart';
import 'package:hichat/theme.dart';

class Logo extends StatelessWidget {
  const Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: isLightTheme(context)
            ? Image.asset('', fit: BoxFit.fill)
            : Image.asset('', fit: BoxFit.fill));
  }
}
