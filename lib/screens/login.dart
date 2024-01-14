// import 'package:cotton/login/signIn.dart';
import 'package:cotton/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:cotton/components/constants.dart';
import 'package:cotton/components/primary_button.dart';
// import 'package:cotton/login/signUp.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Log In"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mainDefaultPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                "assets/cotton.png",
                height: 250,
              ),
              const Spacer(flex: 2),
              PrimaryButton(
                  text: "Sign In",
                  press: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      )),
              const SizedBox(height: mainDefaultPadding * 1.5),
              PrimaryButton(
                color: mainSecondaryColor,
                text: "Sign Up",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
