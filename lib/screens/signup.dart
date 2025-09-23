import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocerease/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final authService = AuthService();

  // final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // final _supabase = Supabase.instance.client;

  void _signup() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    if(password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords don't match")));
      return;
    }

    try{  
      await authService.signUpWithEmailPassword(email, password);
    } catch (e){
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  // Future<void> _signup() async {
  //   final email = _emailController.text.trim();
  //   final password = _passwordController.text.trim();

  //   try {
  //     final response = await _supabase.auth.signUp(email: email, password: password);
  //     if (response.user != null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Signup successful!')),
  //       );
  //       Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD1FBF3),
        image: DecorationImage(
          image: AssetImage('assets/images/login_bg.png'),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          primary: false,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsetsDirectional.fromSTEB(35, 80, 35, 0),
              decoration: BoxDecoration(
                color: Color(0x54FFFFFF),
                borderRadius: BorderRadius.circular(45.0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF4F8E81),
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        color: Color(0xFF4F8E81),
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                  //   child: SizedBox(
                  //     child: TextField(
                  //       obscureText: false,
                  //       controller: _fullNameController,
                  //       style: TextStyle(
                  //         color: Color(0xFF000000)
                  //       ),
                  //       decoration: InputDecoration(
                  //         filled: true,
                  //         fillColor: Color.fromARGB(255, 255, 255, 255),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(5)
                  //         ),
                  //         hintText: 'Full Name',
                  //         hintStyle: TextStyle(
                  //           color: Color.fromARGB(255, 144, 160, 183),
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    child: SizedBox(
                      child: TextField(
                        obscureText: false,
                        controller: _emailController,
                        style: TextStyle(
                          color: Color(0xFF000000)
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 144, 160, 183),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    child: SizedBox(
                      child: TextField(
                        obscureText: true,
                        controller: _passwordController,
                        style: TextStyle(
                          color: Color(0xFF000000)
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 144, 160, 183),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    child: SizedBox(
                      child: TextField(
                        obscureText: true,
                        controller: _confirmPasswordController,
                        style: TextStyle(
                          color: Color(0xFF000000)
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 144, 160, 183),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    width: 351.0,
                    height: 37.0,
                    child: SizedBox(
                      child: FilledButton(
                        onPressed: _signup,//() => Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false),
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )
                          )
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    )
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Container(
                  //       alignment: Alignment.center,
                  //       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                  //       //width: 110,
                  //       child: GestureDetector(
                  //         onTap:() => debugPrint('Facebook login Tapped!'),
                  //         // child: Image.asset(
                  //         //   'assets/images/facebook-circle-fill.png',
                  //         //   height: 40,
                  //         // ),
                  //       ),
                  //     ),
                  //     Container(
                  //       alignment: Alignment.center,
                  //       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                  //       width: 130,
                  //       child: GestureDetector(
                  //         onTap: () => debugPrint('Google login Tapped!'),
                  //         // child: Image.asset(
                  //         //   'assets/images/google 3.png',
                  //         //   height: 35,
                  //         // ),
                  //       ),
                  //     ),
                  //     Container(
                  //       alignment: Alignment.center,
                  //       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
                  //       //width: 110,
                  //       child: GestureDetector(
                  //         onTap: () => debugPrint('Apple login Tapped!'),
                  //         // child: Image.asset(
                  //         //   'assets/images/apple-fill.png',
                  //         //   height: 35,
                  //         // ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 72.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    child: Text("Already have an account?")
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
          ]
        )
      ),
    );
  }
}