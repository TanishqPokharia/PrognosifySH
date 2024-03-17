import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/auth/auth_services.dart';
import 'package:prognosify/auth/google_sign_in.dart';
import 'package:prognosify/router/app_router_constants.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKeySignIn = GlobalKey<FormState>();
  bool _passwordHideStatus = true;
  String email = "";
  String password = "";
  bool waiting = false;

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Form(
              key: _formKeySignIn,
              child: Container(
                padding: EdgeInsets.all(mq(context, 15)),
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
                          key: const ValueKey("emailSignIn"),
                          validator: (value) {
                            if (value!.length < 5) {
                              return "Not a valid email";
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
                                "Email",
                                style: TextStyle(fontSize: mq(context, 25)),
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
                        key: const ValueKey("passwordSignIn"),
                        validator: (value) {
                          if (value!.length < 5) {
                            return "Create a strong password";
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
                    Padding(
                      padding: EdgeInsets.only(
                          top: mq(context, 35), right: mq(context, 45)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("Response");
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                  fontSize: mq(context, 21),
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: mq(context, 45)),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: mq(context, 65)),
                            height: mq(context, 65),
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKeySignIn.currentState!.validate()) {
                                    _formKeySignIn.currentState!.save();
                                    AuthServices.signInUser(
                                        email, password, context);
                                  }
                                },
                                child: Text("Sign In",
                                    style:
                                        TextStyle(fontSize: mq(context, 21)))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            waiting
                ? const Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ));
  }
}
