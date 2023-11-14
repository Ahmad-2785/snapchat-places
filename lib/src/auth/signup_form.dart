import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  Map<String, String> _errors = {};

  void _submitForm() {
    setState(() {
      _errors = {};
    });
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Signup'),
            content: Text('Successful signup!'),
          );
        },
      );
    } else {
      setState(() {
        // Update state with error messages
        _errors = {
          'email': _formKey.currentState!.errors['email']?.first,
          'password': _formKey.currentState!.errors['password']?.first,
          'confirmPassword':
              _formKey.currentState!.errors['confirmPassword']?.first,
        };
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fix the validation errors.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              bool emailValid = RegExp(
                      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$')
                  .hasMatch(value);
              if (!emailValid) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            onSaved: (value) {
              print(value);
              _email = value!;
            },
            onChanged: (value) {
              _email = value!;
              print(value);
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password should be at least 6 characters';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value != _password) {
                return 'Passwords do not match';
              }
              return null;
            },
            onSaved: (value) {
              _confirmPassword = value!;
            },
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: _submitForm,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Signup Form'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SignupForm(),
        ),
      ),
    );
  }
}
