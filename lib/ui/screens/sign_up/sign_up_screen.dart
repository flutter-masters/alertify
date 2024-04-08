import 'package:flutter/material.dart';

import '../../shared/extensions/build_context.dart';
import '../../shared/validators/form_validator.dart';
import '../../shared/widgets/flutter_masters_rich_text.dart';
import '../home/home_screen.dart';
import '../sign_in/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String route = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final formKey = GlobalKey<FormState>();

  var userName = '';
  var email = '';
  var password = '';

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    return context.pushNamedAndRemoveUntil<void>(HomeScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: FormValidator.userName,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'Your username here',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      onChanged: (value) => setState(() => userName = value),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: FormValidator.email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Your email here',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      onChanged: (value) => setState(() => email = value),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: FormValidator.password,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'Your password here',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      onChanged: (value) => setState(() => password = value),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: (value) => FormValidator.confirmPassword(
                        value,
                        password,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'Confirm password here',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: signUp,
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 56),
                    FlutterMastersRichText(
                      text: 'Already have an Account?',
                      secondaryText: 'Sign In',
                      onTap: () => context.pushNamed(SignInScreen.route),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
