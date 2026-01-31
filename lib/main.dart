import 'package:flutter/material.dart';
import 'package:tic_tac/core/theme.dart';
import 'package:tic_tac/pages/start.dart';
import 'package:tic_tac/services/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.darkTheme,
      // ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}
