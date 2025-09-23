import 'package:flutter/material.dart';
import 'package:grocerease/supabase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseOptions.SUPABASE_URL,
    anonKey: SupabaseOptions.SUPABASE_ANON_KEY
  );
  runApp(App());
}