import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/auth/auth_services.dart';
import 'package:prognosify/router/app_router_constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKeySignUp = GlobalKey<FormState>();
  bool _passwordHideStatus = true;
  String fullName = "";
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKeySignUp,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Hero(
                  tag: "Tag",
                  child: Image.asset(
                    "assets/applogo.png",
                    width: 300,
                    height: 200,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 50, right: 40, left: 40),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18),
                    key: ValueKey("emailSignUp"),
                    validator: (value) {
                      if (value!.length < 5 ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "Please enter a valid email";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      setState(() {
                        email = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        label: Text(
                          "Email", style: TextStyle(fontSize: 20),
                          // style: TextStyle(fontSize: 20),
                        )),
                  )),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  style: TextStyle(fontSize: 18),
                  key: ValueKey("fullname"),
                  validator: (value) {
                    if (!value!.contains(" ")) {
                      return "Please enter your full name";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      fullName = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    label: Text(
                      "Full Name",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  style: TextStyle(fontSize: 18),
                  key: ValueKey("passwordSignUp"),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return "Please create a strong password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      password = newValue!;
                    });
                  },
                  obscureText: _passwordHideStatus,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      label: Text(
                        "Password",
                        style: TextStyle(fontSize: 20),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordHideStatus
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _passwordHideStatus = !_passwordHideStatus;
                          });
                        },
                      )),
                ),
              ),
              Container(padding: EdgeInsets.only(top: 40)),
              Container(
                margin: EdgeInsets.only(top: 60),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKeySignUp.currentState!.validate()) {
                        _formKeySignUp.currentState!.save();
                        AuthServices.signUpUser(
                            email, fullName, password, context);
                      }
                    },
                    child: Text("Sign Up", style: TextStyle(fontSize: 18))),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, right: 40, left: 40),
                child: Wrap(
                  spacing: 5,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                        onTap: () {
                          GoRouter.of(context)
                              .goNamed(AppRouterConstants.signInScreen);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
