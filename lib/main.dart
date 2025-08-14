import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'home.dart';
import 'dart:async';
import 'restartapp.dart';
import 'package:flutter/foundation.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';
late final FirebaseApp app;
late final FirebaseAuth auth;
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  app = await Firebase.initializeApp();
  auth = FirebaseAuth.instanceFor(app: app);
  await Firebase.initializeApp();
  processStart();
}
void processStart()async{
  runApp(
    const RestartWidget(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  static const String _title = 'BuildTrackr';
  static Map<int, Color> colorMat = {
    50: const Color.fromRGBO(0, 0, 37, .1),
    100: const Color.fromRGBO(0, 0, 37, .2),
    200: const Color.fromRGBO(0, 0, 37, .3),
    300: const Color.fromRGBO(0, 0, 37, .4),
    400: const Color.fromRGBO(0, 0, 37, .5),
    500: const Color.fromRGBO(0, 0, 37, .6),
    600: const Color.fromRGBO(0, 0, 37, .7),
    700: const Color.fromRGBO(0, 0, 37, .8),
    800: const Color.fromRGBO(0, 0, 37, .9),
    900: const Color.fromRGBO(0, 0, 37, 1),
  };
  static MaterialColor colorB = MaterialColor(0xFF000026, colorMat);
  final Color darkBlue = const Color(0xff000026);

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
        primarySwatch: colorB,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}