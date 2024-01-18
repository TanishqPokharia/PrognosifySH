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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKeySignIn,
          child: Container(
            padding: EdgeInsets.all(10),
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
                      key: ValueKey("emailSignIn"),
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
                    key: ValueKey("passwordSignIn"),
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
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 40),
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
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        height: 60,
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
                                style: TextStyle(fontSize: 18))),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        height: 60,
                        width: double.infinity,
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                            width: 1, color: Colors.teal)))),
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin(context);
                            },
                            child: Wrap(
                              spacing: 10,
                              children: [
                                FaIcon(FontAwesomeIcons.google),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, right: 40, left: 40),
                  child: Wrap(
                    spacing: 5,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 18),
                      ),
                      GestureDetector(
                          onTap: () {
                            GoRouter.of(context)
                                .goNamed(AppRouterConstants.signUpScreen);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
