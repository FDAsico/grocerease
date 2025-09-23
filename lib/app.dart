import 'package:flutter/material.dart';
import 'package:grocerease/route_generator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'GrocerEase',
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4F8E81),
          primary: Color(0xFF4F8E81),
        ),
      ),
      themeMode: ThemeMode.system,
    );
  }
}
