import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocerease/auth/auth_service.dart';
import 'package:grocerease/main.dart';
import 'package:grocerease/screens/home.dart';
import 'package:grocerease/screens/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // void _login() async {
  //   final email = _emailController.text;
  //   final password = _passwordController.text;

  //   try {
  //     await authService.signInWithEmailPassword(email, password);
  //   } catch(e) {
  //     if(mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
  //     }
  //   }
  // }

  // Future<AuthResponse> _googleSignIn() async {
  //   /// TODO: update the Web client ID with your own.
  //   ///
  //   /// Web Client ID that you registered with Google Cloud.
  //   const webClientId = '624800388293-9k21ootr3otqb4q3pvj938pdeorb0m3p.apps.googleusercontent.com';

  //   /// TODO: update the iOS client ID with your own.
  //   ///
  //   /// iOS Client ID that you registered with Google Cloud.
  //   const iosClientId = '624800388293-d1l6b5v3bms8n9htjp3krb05a8iv8o05.apps.googleusercontent.com';

  //   // Google sign in on Android will work without providing the Android
  //   // Client ID registered on Google Cloud.

  //   final GoogleSignIn googleSignIn = GoogleSignIn(
  //     clientId: iosClientId,
  //     serverClientId: webClientId,
  //   );
  //   final googleUser = await googleSignIn.signIn();
  //   final googleAuth = await googleUser!.authentication;
  //   final accessToken = googleAuth.accessToken;
  //   final idToken = googleAuth.idToken;

  //   if (accessToken == null) {
  //     throw 'No Access Token found.';
  //   }
  //   if (idToken == null) {
  //     throw 'No ID Token found.';
  //   }

  //   return supabase.auth.signInWithIdToken(
  //     provider: OAuthProvider.google,
  //     idToken: idToken,
  //     accessToken: accessToken,
  //   );
  // }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      final response = await authService.signInWithEmailPassword(email, password);
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (Route<dynamic> route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
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
              // decoration: BoxDecoration(
              //   color: Color(0x54FFFFFF),
              //   borderRadius: BorderRadius.circular(45.0),
              // ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Text(
                      'Sign In',
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
                      "Enter Credentials",
                      style: TextStyle(
                        color: Color(0xFF4F8E81),
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
      
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
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
                    margin: EdgeInsets.fromLTRB(5.0, 8.0, 5.0, 8.0),
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
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/forgot'),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 25.0),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    )
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 25.0),
                    width: 351.0,
                    height: 37.0,
                    child: SizedBox(
                      child: FilledButton(
                        onPressed: _login ,//() => Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Color(0xFFFA8801)
                        ),
                        child: Text(
                          'Sign In',
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
                    child: Text("Don't have an account?")
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Signup(),
                      )
                    ),
                    child: SizedBox(
                      child: Text(
                        'Sign Up',
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