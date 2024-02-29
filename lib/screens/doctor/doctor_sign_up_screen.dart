import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dob_input_field/dob_input_field.dart';
import 'package:prognosify/auth/auth_services.dart';

class DoctorSignUpScreen extends StatefulWidget {
  const DoctorSignUpScreen({super.key});

  @override
  State<DoctorSignUpScreen> createState() => _DoctorSignUpScreenState();
}

class _DoctorSignUpScreenState extends State<DoctorSignUpScreen> {
  final _formKeySignUp = GlobalKey<FormState>();
  final List<DropdownMenuEntry<String>> medicalCouncilsList = const [
    DropdownMenuEntry(
        value: 'Andhra Pradesh Medical Council',
        label: 'Andhra Pradesh Medical Council'),
    DropdownMenuEntry(
        value: 'Arunachal Pradesh Medical Council',
        label: 'Arunachal Pradesh Medical Council'),
    DropdownMenuEntry(
        value: 'Assam Medical Council', label: 'Assam Medical Council'),
    DropdownMenuEntry(
        value: 'Bhopal Medical Council', label: 'Bhopal Medical Council'),
    DropdownMenuEntry(
        value: 'Bihar Medical Council', label: 'Bihar Medical Council'),
    DropdownMenuEntry(
        value: 'Bombay Medical Council', label: 'Bombay Medical Council'),
    DropdownMenuEntry(
        value: 'Chandigarh Medical Council',
        label: 'Chandigarh Medical Council'),
    DropdownMenuEntry(
        value: 'Chattisgarh Medical Council',
        label: 'Chattisgarh Medical Council'),
    DropdownMenuEntry(
        value: 'Delhi Medical Council', label: 'Delhi Medical Council'),
    DropdownMenuEntry(
        value: 'Goa Medical Council', label: 'Goa Medical Council'),
    DropdownMenuEntry(
        value: 'Gujarat Medical Council', label: 'Gujarat Medical Council'),
    DropdownMenuEntry(
        value: 'Haryana Medical Councils', label: 'Haryana Medical Councils'),
    DropdownMenuEntry(
        value: 'Himachal Pradesh Medical Council',
        label: 'Himachal Pradesh Medical Council'),
    DropdownMenuEntry(
        value: 'Hyderabad Medical Council', label: 'Hyderabad Medical Council'),
    DropdownMenuEntry(
        value: 'Jammu & Kashmir Medical Council',
        label: 'Jammu & Kashmir Medical Council'),
    DropdownMenuEntry(
        value: 'Jharkhand Medical Council', label: 'Jharkhand Medical Council'),
    DropdownMenuEntry(
        value: 'Karnataka Medical Council', label: 'Karnataka Medical Council'),
    DropdownMenuEntry(
        value: 'Madhya Pradesh Medical Council',
        label: 'Madhya Pradesh Medical Council'),
    DropdownMenuEntry(
        value: 'Madras Medical Council', label: 'Madras Medical Council'),
    DropdownMenuEntry(
        value: 'Mahakoshal Medical Council',
        label: 'Mahakoshal Medical Council'),
    DropdownMenuEntry(
        value: 'Maharashtra Medical Council',
        label: 'Maharashtra Medical Council'),
    DropdownMenuEntry(
        value: 'Manipur Medical Council', label: 'Manipur Medical Council'),
    DropdownMenuEntry(
        value: 'Medical Council of India', label: 'Medical Council of India'),
    DropdownMenuEntry(
        value: 'Medical Council of Tanganyika',
        label: 'Medical Council of Tanganyika'),
    DropdownMenuEntry(
        value: 'Mizoram Medical Council', label: 'Mizoram Medical Council'),
    DropdownMenuEntry(
        value: 'Mysore Medical Council', label: 'Mysore Medical Council'),
    DropdownMenuEntry(
        value: 'Nagaland Medical Council', label: 'Nagaland Medical Council'),
    DropdownMenuEntry(
        value: 'Orissa Council of Medical Registration',
        label: 'Orissa Council of Medical Registration'),
    DropdownMenuEntry(
        value: 'Pondicherry Medical Council',
        label: 'Pondicherry Medical Council'),
    DropdownMenuEntry(
        value: 'Punjab Medical Council', label: 'Punjab Medical Council'),
    DropdownMenuEntry(
        value: 'Rajasthan Medical Council', label: 'Rajasthan Medical Council'),
    DropdownMenuEntry(
        value: 'Sikkim Medical Council', label: 'Sikkim Medical Council'),
    DropdownMenuEntry(
        value: 'Tamil Nadu Medical Council',
        label: 'Tamil Nadu Medical Council'),
    DropdownMenuEntry(
        value: 'Telangana State Medical Council',
        label: 'Telangana State Medical Council'),
    DropdownMenuEntry(
        value: 'Travancore Cochin Medical Council, Trivandrum',
        label: 'Travancore Cochin Medical Council, Trivandrum'),
    DropdownMenuEntry(
        value: 'Tripura State Medical Council',
        label: 'Tripura State Medical Council'),
    DropdownMenuEntry(
        value: 'Uttar Pradesh Medical Council',
        label: 'Uttar Pradesh Medical Council'),
    DropdownMenuEntry(
        value: 'Uttarakhand Medical Council',
        label: 'Uttarakhand Medical Council'),
    DropdownMenuEntry(
        value: 'Vidharba Medical Council', label: 'Vidharba Medical Council'),
    DropdownMenuEntry(
        value: 'West Bengal Medical Council',
        label: 'West Bengal Medical Council'),
  ];

  bool _passwordHideStatus = true;
  String fullName = "";
  String email = "";
  String registrationNumber = "";
  String password = "";
  String dateOfRegistration = "";
  String dob = "";
  String medicalCouncil = "Andhra Pradesh Medical Council";
  String qualification = "";
  String qualificationDate = "";
  String universityName = "";
  String aadharNumber = '';

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
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
                  margin: EdgeInsets.symmetric(
                      horizontal: mq(context, 45), vertical: mq(context, 10)),
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
                          "Email", style: TextStyle(fontSize: mq(context, 21)),
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "Full Name",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                  ),
                ),
              ),
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
                      dob = DateFormat("dd/MM/yyyy").format(value);
                    });
                  },
                  onDateSaved: (value) {
                    setState(() {
                      dob = DateFormat("dd/MM/yyyy").format(value);
                    });
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: mq(context, 45), vertical: mq(context, 10)),
                  child: TextFormField(
                    style: TextStyle(fontSize: mq(context, 21)),
                    key: const ValueKey("regNumber"),
                    validator: (value) {
                      if (value!.length < 5 || value.isEmpty) {
                        return "Please enter a valid registration number";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      setState(() {
                        registrationNumber = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(mq(context, 25)))),
                        label: Text(
                          "Registration Number",
                          style: TextStyle(fontSize: mq(context, 21)),
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
                  fieldLabelText: "Date of registration",
                  fieldHintText: "DD/MM/YYYY",
                  onDateSubmitted: (value) {
                    setState(() {
                      dateOfRegistration =
                          DateFormat('dd/MM/yyyy').format(value);
                    });
                  },
                  onDateSaved: (value) {
                    dateOfRegistration = DateFormat('dd/MM/yyyy').format(value);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 20), vertical: mq(context, 10)),
                child: DropdownMenu<String>(
                  width: mq(context, 390),
                  label: const Text("Select Medical Council"),
                  menuHeight: mq(context, 300),
                  dropdownMenuEntries: medicalCouncilsList,
                  initialSelection: medicalCouncilsList[0].value,
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(fontSize: mq(context, 20)),
                      hintStyle: TextStyle(fontSize: mq(context, 20)),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(mq(context, 25)))),
                  onSelected: (value) {
                    setState(() {
                      medicalCouncil = value!;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 45), vertical: mq(context, 10)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("qualificationName"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter proper qualification name";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      qualification = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "Qualification",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                  ),
                ),
              ),
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
                  fieldLabelText: "Qualification Date",
                  fieldHintText: "DD/MM/YYYY",
                  onDateSubmitted: (value) {
                    setState(() {
                      qualificationDate =
                          DateFormat("dd/MM/yyyy").format(value);
                    });
                  },
                  onDateSaved: (value) {
                    qualificationDate = DateFormat("dd/MM/yyyy").format(value);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 45), vertical: mq(context, 10)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("uniName"),
                  validator: (value) {
                    if (!value!.contains(" ")) {
                      return "Please enter proper university name";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      universityName = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "University Name",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 45), vertical: mq(context, 10)),
                child: TextFormField(
                  style: TextStyle(fontSize: mq(context, 21)),
                  key: const ValueKey("aadhar"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter proper aadhar number";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      aadharNumber = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(mq(context, 25)))),
                    label: Text(
                      "Aadhar Number",
                      style: TextStyle(fontSize: mq(context, 21)),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: mq(context, 45), vertical: mq(context, 10)),
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
                        style: TextStyle(fontSize: mq(context, 21)),
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
                margin: EdgeInsets.symmetric(vertical: mq(context, 55)),
                padding: EdgeInsets.symmetric(horizontal: mq(context, 45)),
                height: mq(context, 65),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKeySignUp.currentState!.validate()) {
                        _formKeySignUp.currentState!.save();
                        AuthServices.signUpDoctor(
                            context,
                            email,
                            fullName,
                            dob,
                            registrationNumber,
                            dateOfRegistration,
                            medicalCouncil,
                            qualification,
                            qualificationDate,
                            universityName,
                            aadharNumber,
                            password);
                        return;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all the details")));
                      }
                    },
                    child: Text("Sign Up",
                        style: TextStyle(fontSize: mq(context, 21)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
