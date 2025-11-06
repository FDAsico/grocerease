import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final supabase = Supabase.instance.client;

  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      await supabase.auth.resetPasswordForEmail(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset link sent to your email")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFD1FBF3),
        image: DecorationImage(
          image: AssetImage('assets/images/login_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          primary: false,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsetsDirectional.fromSTEB(35, 80, 35, 0),
              decoration: BoxDecoration(
                color: const Color(0x54FFFFFF),
                borderRadius: BorderRadius.circular(45.0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                    child: const Text(
                      "Enter your email",
                      style: TextStyle(
                        color: Color(0xFF4F8E81),
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 25.0),
                    child: SizedBox(
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 144, 160, 183),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
                    width: 351.0,
                    height: 37.0,
                    child: FilledButton(
                      onPressed: _sendResetLink,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF4F8E81),
                        ),
                      ),
                      child: const Text(
                        'Send Reset Link',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(top: 40.0),
                alignment: Alignment.center,
                child: const Text(
                  "Back to Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

