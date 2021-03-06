
import 'package:ems_direct/pages/SelectLogin.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/pages/emergency_numbers.dart';
import 'package:ems_direct/pages/login_student.dart';
import 'package:ems_direct/pages/login_ems.dart';
import 'package:ems_direct/pages/SplashScreen.dart';
import 'package:ems_direct/available_mfrs.dart';
import 'package:ems_direct/senior_mfrs.dart';

// Main file sets intial route

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/login_student': (context) => LoginStudent(),
        '/login_ems_mfr': (context) => LoginEms('mfr'),
        '/login_ems_ops': (context) => LoginEms('ops'),
      //  '/live_status': (context) => LiveStatus(),
        '/emergencyNumbers': (context) => EmergencyNumbers(),
        '/select_login': (context) => SelectLogin(),
        '/availableMfrs': (context) => AvailableMfrsList(),
        '/seniorMfrs': (context) => SeniorMfrs(),
        //'/dummy': (context) => DummyPage(),
      },
    );
  }
}
