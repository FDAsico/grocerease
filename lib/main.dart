import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final supabase = Supabase.instance.client;

// int? initScreen;
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // initScreen = prefs.getInt('initScreen');
  // //await prefs.setInt("initScreen", 1);
  // debugPrint('initScreen $initScreen');
  runApp(const App());
}
