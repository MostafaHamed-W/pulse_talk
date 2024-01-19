import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pulse_talk/screens/widgets/scaffold_messanger.dart';
import 'package:pulse_talk/screens/widgets/user_image_picker.dart';
import 'package:pulse_talk/utils/app_colors.dart';
import 'package:pulse_talk/utils/app_styles.dart';
import 'package:pulse_talk/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  File? userImage;

  void _onSubmit() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();

    if (!isValid || userImage == null) {
      setState(() {
        _isLoading = false;
      });
      if (userImage == null) {
        showCustomSnackbar(context: context, message: 'Please chose an image!');
      }
      return;
    }
    _formKey.currentState!.save();

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _passwordController.text,
      );
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredential.user!.uid}.jpg');

      await storageRef.putFile(userImage!);
      final imageUrl = storageRef.getDownloadURL();
      print(imageUrl);

      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Account created succefully, please login now',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: error.message,
          spareError: "Unknown Auth Exception",
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailcontroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create email'),
        backgroundColor: AppColor.kPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  UserImagePicker(
                    onSelectImage: (pickedImage) {
                      userImage = pickedImage;
                    },
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.trim().length < 4) {
                                        return 'Please enter a valid name';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      border: AppStyle.outlineInputBorder,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _emailcontroller,
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
                                      labelText: 'Email address',
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
                                        return 'Password must be at least 7 characters';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      // border: OutlineInputBorder(),
                                      label: Text('Password'),
                                      border: AppStyle.outlineInputBorder,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.trim().length < 6) {
                                        return 'Password must be at least 7 characters';
                                      } else if (value != _passwordController.text) {
                                        return 'Password not matched!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      // border: OutlineInputBorder(),
                                      label: Text('Confirm password'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _onSubmit,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xfffab714)),
                                    child: const SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Signup',
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
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    ),
                                    child: RichText(
                                      text: const TextSpan(
                                        text: "Already have email?",
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: " Login now",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
