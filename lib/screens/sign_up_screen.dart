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

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

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
                    width: mq(context, 350),
                    height: mq(context, 250),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                      top: mq(context, 55),
                      right: mq(context, 45),
                      left: mq(context, 45)),
                  child: TextFormField(
                    style: TextStyle(fontSize: mq(context, 21)),
                    key: const ValueKey("emailSignUp"),
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(mq(context, 25)))),
                        label: Text(
                          "Email", style: TextStyle(fontSize: mq(context, 25)),
                          // style: TextStyle(fontSize: 20),
                        )),
                  )),
              SizedBox(
                height: mq(context, 55),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 45)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("fullname"),
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
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "Full Name",
                      style: TextStyle(fontSize: mq(context, 25)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mq(context, 55),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: mq(context, 45)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("passwordSignUp"),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(mq(context, 25)))),
                      label: Text(
                        "Password",
                        style: TextStyle(fontSize: mq(context, 25)),
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
              Container(padding: EdgeInsets.only(top: mq(context, 45))),
              Container(
                margin: EdgeInsets.only(top: mq(context, 65)),
                padding: EdgeInsets.symmetric(horizontal: mq(context, 45)),
                height: mq(context, 65),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKeySignUp.currentState!.validate()) {
                        _formKeySignUp.currentState!.save();
                        AuthServices.signUpUser(
                            email, fullName, password, context);
                      }
                    },
                    child: Text("Sign Up",
                        style: TextStyle(fontSize: mq(context, 21)))),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: mq(context, 35),
                    right: mq(context, 45),
                    left: mq(context, 45)),
                child: Wrap(
                  spacing: mq(context, 10),
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                    GestureDetector(
                        onTap: () {
                          GoRouter.of(context)
                              .goNamed(AppRouterConstants.signInScreen);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mq(context, 21)),
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
