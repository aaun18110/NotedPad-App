import 'package:flutter/material.dart';
import 'package:local_database/Screen/splashscreen.dart';
import 'package:local_database/Screen/write_notes.dart';
import 'package:local_database/Utils/routes.dart';
import 'package:local_database/Screen/read_notes.dart';

import '../Screen/homescreen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteName.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case RouteName.readNotes:
        return MaterialPageRoute(builder: (context) => const ReadNotes());
      case RouteName.writeNotes:
        return MaterialPageRoute(builder: (context) => const WriteNotes());
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: SafeArea(child: Center(child: Text("404 Error"))),
          );
        });
    }
  }
}
