import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_examples/authentication/home_page.dart';
import 'package:flutter_firebase_examples/authentication/registration_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIN extends StatefulWidget {
  const SignIN({Key? key}) : super(key: key);

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailTextField = TextFormField(
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your email";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return "Please enter a correct email";
        }
        return null;
      },
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 18),
        labelText: "Email",
        prefixIcon: Icon(Icons.email),
      ),
      onSaved: (newValue) {
        emailController.text = newValue!;
      },
    );

    final passwordTextField = TextFormField(
      controller: passwordController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required for login";
        }
        if (!regex.hasMatch(value)) {
          return "Please enter valid password (Min. 6 character)";
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 18),
        labelText: "Password",
        prefixIcon: Icon(Icons.key),
      ),
      onSaved: (newValue) {
        passwordController.text = newValue!;
      },
    );

    final signInButton = Material(
      elevation: 5,
      child: SizedBox(
        width: 250,
        height: 40,
        child: ElevatedButton.icon(
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          icon: const Icon(Icons.lock_open),
          label: const Text(
            "Sign in",
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 50),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  _logo(),
                  emailTextField,
                  const SizedBox(height: 10),
                  passwordTextField,
                  const SizedBox(height: 100),
                  signInButton,
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          "Don't have an account ?",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 236, 191, 191),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const RegistrationPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center _logo() {
    return const Center(
      child: FlutterLogo(
        size: 300,
      ),
    );
  }

  void signIn(String email, String password) async {
    if (key.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (uuid) {
          Fluttertoast.showToast(msg: "Login successful");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      ).catchError(
        (e) {
          Fluttertoast.showToast(msg: e.message);
        },
      );
    }
  }
}
