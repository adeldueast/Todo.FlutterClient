import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickmyflutter/models/DTOs/SignupRequest.dart';
import 'package:provider/provider.dart';

import '../../../models/User.dart';
import '../../../services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.onClickedSignIn}) : super(key: key);
  final Function() onClickedSignIn;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                child: const FlutterLogo(
                  size: 40,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Username',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid password';
                    } else if (_passwordController.text !=
                        _password2Controller.text) {
                      return 'Both password must be identical';
                    } else if (value.length < 4) {
                      return 'Password too short';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _password2Controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid password';
                    } else if (_passwordController.text !=
                        _password2Controller.text) {
                      return 'Both password must be identical';
                    } else if (value.length < 4) {
                      return 'Password too short';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Password confirmation',
                  ),
                ),
              ),
              Container(
                  height: 80,
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _submitted ? null : _submit,
                    child: const Text('Register'),
                  )),
              TextButton(
                onPressed:   _submitted ? null : widget.onClickedSignIn,
                child: const Text(
                  'sign in',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   _signUp() async {
    setState(()=>_submitted = true);
    try {
      final SignupRequest request =
      SignupRequest(_emailController.text, _passwordController.text);
      final signUpResponse = await signUp(request);
      Provider.of<UserModel>(context, listen: false).user =
          User(signUpResponse.username);
    } on DioError catch (e) {
     //handle error
    }

    setState(()=>_submitted = false);
  }
  _submit() {

    if (_formKey.currentState!.validate()) _signUp();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }
}
