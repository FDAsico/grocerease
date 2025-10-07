import 'package:flutter/material.dart';
import 'package:grocerease/auth/auth_service.dart';
import 'package:grocerease/screens/login.dart';
import 'package:grocerease/screens/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final activeSession = supabase.auth.currentSession;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    if (activeSession == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void logout() async {
    await authService.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen())), icon: Icon(Icons.notifications)),
          IconButton(onPressed: logout, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}