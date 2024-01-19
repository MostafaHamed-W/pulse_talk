import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pulse_talk/screens/chat.dart';
import 'package:pulse_talk/screens/widgets/scaffold_messanger.dart';
import 'package:pulse_talk/screens/widgets/user_image_picker.dart';
import 'package:pulse_talk/utils/app_colors.dart';
import 'package:pulse_talk/screens/signup.dart';
import 'package:pulse_talk/utils/app_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // print(userCredential);
        // if (context.mounted) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const ChatScreen(),
        //     ),
        //   );
        // }
      } on FirebaseAuthException catch (e) {
        print('exception');
        if (context.mounted) {
          showCustomSnackbar(context: context, message: e.message);
        }
      }
    } else {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Pulse Talk'),
          ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                left: 65,
                right: 65,
                bottom: 20,
              ),
              child: Image.asset('assets/images/logo.png'),
            ),
            Card(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              color: Colors.transparent,
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || !value.contains('@')) {
                                  return 'Please enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                border: AppStyle.outlineInputBorder,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Please enter valid password';
                                } else {
                                  return null;
                                }
                              },
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text('Password'),
                                border: AppStyle.outlineInputBorder,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.kPrimary,
                              ),
                              child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              ),
                              child: RichText(
                                text: const TextSpan(
                                  text: "Don't have email?",
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: " create new one",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
