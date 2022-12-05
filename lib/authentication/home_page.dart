import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_examples/authentication/model/user_model.dart';
import 'package:flutter_firebase_examples/authentication/sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "User information",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
          ),
          child: Column(
            children: [
              const FlutterLogo(
                size: 150,
              ),
              const SizedBox(height: 40),
              Text(
                "${loggedUser.name} ${loggedUser.surname}",
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 40),
              Text(
                "${loggedUser.email}",
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    logOut(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Log out",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignIN(),
      ),
    );
  }
}
