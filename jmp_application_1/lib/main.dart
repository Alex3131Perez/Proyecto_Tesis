import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jmp_application_1/Vistas/login_screen.dart';
import 'package:jmp_application_1/Vistas/splash_screen.dart';
import 'Resgistros/Reg_Alimento.dart';
import 'Resgistros/Reg_Rancho.dart';
import 'Resgistros/Reg_Traslados.dart';
import 'Resgistros/Reg_Venta.dart';
import 'datebase/db_helper.dart';
import 'Perfil_Rancho.dart'; // Ajusta la ruta si lo tienes en otra carpeta

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6D4C41),
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF6D4C41),
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Text('Algo salió mal', style: TextStyle(color: Colors.red)),
      ),
    );
  };

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JMP Ganadera',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color(0xFF4E342E),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
