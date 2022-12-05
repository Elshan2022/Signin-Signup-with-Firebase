import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_examples/authentication/home_page.dart';
import 'package:flutter_firebase_examples/authentication/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final auth = FirebaseAuth.instance;
  final key = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  @override
  void initState() {
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const flutterLogo = FlutterLogo(size: 250);
    final nameTextField = TextFormField(
      keyboardType: TextInputType.name,
      controller: nameController,
      decoration: InputDecoration(
        labelText: "Name",
        prefixIcon: Image.asset(
          "assets/nameIcon.png",
          color: Colors.white,
        ),
      ),
      onSaved: (newValue) {
        nameController.text = newValue!;
      },
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return "Name can't be empty";
        }
        if (!regex.hasMatch(value)) {
          return "Please enter valid name (Min. 3 character)";
        }
        return null;
      },
    );
    final surnameTextField = TextFormField(
      keyboardType: TextInputType.name,
      controller: surnameController,
      decoration: InputDecoration(
        labelText: "Surname",
        prefixIcon: Image.asset(
          "assets/nameIcon.png",
          color: Colors.white,
        ),
      ),
      onSaved: (newValue) {
        surnameController.text = newValue!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Surname can't be empty";
        }
        return null;
      },
    );
    final emailTextField = TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: const InputDecoration(
          labelText: "Email",
          prefixIcon: Icon(Icons.email),
        ),
        onSaved: (newValue) {
          emailController.text = newValue!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your email";
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return "Please enter a correct email";
          }
          return null;
        });
    final passwordTextField = TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        prefixIcon: Icon(Icons.key),
      ),
      onSaved: (newValue) {
        passwordController.text = newValue!;
      },
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
    );
    final confirmPasswordTextField = TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Confirm password",
        prefixIcon: Icon(Icons.key),
      ),
      onSaved: (newValue) {
        confirmPasswordController.text = newValue!;
      },
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return "Password doesn't match";
        }
        return null;
      },
    );
    final signUpButton = SizedBox(
      width: 250,
      height: 40,
      child: ElevatedButton.icon(
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        icon: const Icon(Icons.login),
        label: const Text(
          "Sign up",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  flutterLogo,
                  nameTextField,
                  const SizedBox(height: 10),
                  surnameTextField,
                  const SizedBox(height: 10),
                  emailTextField,
                  const SizedBox(height: 10),
                  passwordTextField,
                  const SizedBox(height: 10),
                  confirmPasswordTextField,
                  const SizedBox(height: 40),
                  signUpButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (key.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        postDetailsToForeStore();
      }).catchError(
        (e) {
          Fluttertoast.showToast(msg: e!.message);
        },
      );
    }
  }

  void postDetailsToForeStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uuid = user.uid;
    userModel.name = nameController.text;
    userModel.surname = surnameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfuly");

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }
}
