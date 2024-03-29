import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';
import 'package:prognosify/auth/auth_services.dart';

class PatientSignUpScreen extends StatefulWidget {
  const PatientSignUpScreen({super.key});

  @override
  State<PatientSignUpScreen> createState() => _PatientSignUpScreenState();
}

class _PatientSignUpScreenState extends State<PatientSignUpScreen> {
  final _formKeySignUp = GlobalKey<FormState>();
  bool _passwordHideStatus = true;
  String fullName = "";
  String email = "";
  String password = "";
  int? age;
  bool isMale = false;
  bool isFemale = false;
  double weight = 0;
  double height = 0;
  String? gender;
  bool waiting = false;

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
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: mq(context, 30),
                  ),
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
                      margin: EdgeInsets.symmetric(
                          horizontal: mq(context, 45),
                          vertical: mq(context, 10)),
                      child: TextFormField(
                        style: TextStyle(fontSize: mq(context, 21)),
                        key: const ValueKey("emailSignUpKey"),
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
                              "Email",
                              style: TextStyle(fontSize: mq(context, 25)),
                              // style: TextStyle(fontSize: 20),
                            )),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: mq(context, 45), vertical: mq(context, 10)),
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(mq(context, 25)))),
                        label: Text(
                          "Full Name",
                          style: TextStyle(fontSize: mq(context, 25)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mq(context, 45),
                          vertical: mq(context, 10)),
                      child: TextFormField(
                        style: TextStyle(fontSize: mq(context, 21)),
                        key: const ValueKey("weight"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter proper weight";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          setState(() {
                            weight = newValue!.toDouble();
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(mq(context, 25)))),
                            label: Text(
                              "Weight(kilograms)",
                              style: TextStyle(fontSize: mq(context, 25)),
                              // style: TextStyle(fontSize: 20),
                            )),
                      )),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mq(context, 45),
                          vertical: mq(context, 10)),
                      child: TextFormField(
                        style: TextStyle(fontSize: mq(context, 21)),
                        key: const ValueKey("height"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter proper height";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          setState(() {
                            height = newValue!.toDouble();
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(mq(context, 25)))),
                            label: Text(
                              "Height(meters)",
                              style: TextStyle(fontSize: mq(context, 25)),
                              // style: TextStyle(fontSize: 20),
                            )),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: mq(context, 45), vertical: mq(context, 10)),
                    child: DOBInputField(
                      inputDecoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: mq(context, 20)),
                          hintStyle: TextStyle(fontSize: mq(context, 20)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(mq(context, 25)))),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      showLabel: true,
                      showCursor: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      fieldLabelText: "Date of birth",
                      fieldHintText: "DD/MM/YYYY",
                      onDateSubmitted: (value) {
                        setState(() {
                          age = DateTime.now().year - value.year;
                        });
                      },
                      onDateSaved: (value) {
                        setState(() {
                          age = DateTime.now().year - value.year;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: mq(context, 45), vertical: mq(context, 10)),
                    padding: EdgeInsets.all(mq(context, 10)),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Select Gender: ",
                            style: TextStyle(fontSize: mq(context, 20)),
                          ),
                          SizedBox(
                            width: mq(context, 10),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = true;
                                isFemale = false;
                                gender = "Male";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      isMale ? Colors.blue : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(mq(context, 25)),
                                  border: Border.all(width: 1)),
                              padding: EdgeInsets.all(mq(context, 10)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.male,
                                    color: isMale ? Colors.white : Colors.blue,
                                  ),
                                  const Text("Male")
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFemale = true;
                                isMale = false;
                                gender = "Male";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isFemale
                                      ? const Color.fromARGB(255, 233, 30, 213)
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(mq(context, 25)),
                                  border: Border.all(width: 1)),
                              padding: EdgeInsets.all(mq(context, 10)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.female,
                                    color: isFemale
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255, 233, 30, 213),
                                  ),
                                  const Text("Female")
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: mq(context, 45), vertical: mq(context, 10)),
                    child: TextFormField(
                      style: TextStyle(fontSize: mq(context, 21)),
                      key: const ValueKey("passwordSignUpKey"),
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
                  Container(
                    margin: EdgeInsets.only(top: mq(context, 25)),
                    padding: EdgeInsets.symmetric(horizontal: mq(context, 45)),
                    height: mq(context, 65),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKeySignUp.currentState!.validate()) {
                            _formKeySignUp.currentState!.save();
                            if (isMale && age != null && gender != null) {
                              waiting = true;
                              AuthServices.signUpUser(email, fullName, password,
                                  age!, gender!, weight, height, context);
                              waiting = false;
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please fill all the details")));
                              return;
                            }
                          }
                        },
                        child: Text("Sign Up",
                            style: TextStyle(fontSize: mq(context, 21)))),
                  ),
                  SizedBox(
                    height: mq(context, 200),
                  ),
                ],
              ),
              waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Container()
            ]),
          ),
        ));
  }
}
