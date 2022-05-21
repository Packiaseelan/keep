import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep/config/config.dart';
import 'package:keep/ui/screens/login/cubit/login_cubit.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      if (_isLogin) {
        context.read<LoginCubit>().doLogin(_userEmail.trim(), _userPassword.trim());
      } else {
        context.read<LoginCubit>().doRegister(_userEmail.trim(), _userPassword.trim(), _userName.trim());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.only(
        top: 35,
        left: 25,
      ),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 54.0, left: 20.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: const ValueKey('email'),
                            decoration: const InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold, color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                )),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userEmail = value!;
                            },
                          ),
                          if (!_isLogin) const SizedBox(height: 20.0),
                          if (!_isLogin)
                            TextFormField(
                              key: const ValueKey('username'),
                              decoration: const InputDecoration(
                                  labelText: 'USERNAME',
                                  labelStyle: TextStyle(
                                      fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold, color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userName = value!;
                              },
                              // ignore: missing_return
                            ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            key: const ValueKey('password'),
                            decoration: const InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'RobotoCondensed', fontWeight: FontWeight.bold, color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                            ),
                            obscureText: true,

                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a long password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          _buildButton(),
                          Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (c, state) {
        if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        } 
        return Column(
          children: [
            SizedBox(
              height: 57.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.black,
                color: AppTheme.secondaryColor,
                elevation: 10.0,
                child: TextButton(
                  onPressed: _trySubmit,
                  child: Center(
                    child: Text(
                      _isLogin ? "Login" : "Sign up",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 57.0,
              child: Material(
                borderRadius: BorderRadius.circular(40.0),
                color: Colors.white,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Center(
                    child: Text(_isLogin ? "Create new account" : "I already have an account",
                        style: Theme.of(context).textTheme.headline6?.copyWith(color: AppTheme.secondaryColor)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
