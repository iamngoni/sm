import 'package:flutter/material.dart';
import 'package:localregex/localregex.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  final localregex = new LocalRegex();
  final _api = new API();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: isProcessing,
            child: Container(
              padding: EdgeInsets.all(8.0),
              height: height(context),
              width: width(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height(context) * 0.05),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: height(context) * 0.05,
                  ),
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Email cannot be empty";
                              }

                              if (!localregex.isEmail(value)) {
                                return "Not an email";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Password cannot be empty";
                              }

                              if (value.toString().length < 6) {
                                return "Password is too short";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            width: width(context),
                            color: Colors.blue,
                            child: MaterialButton(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () async {
                                if (_key.currentState.validate()) {
                                  setState(() {
                                    isProcessing = true;
                                  });
                                  var response = await _api.login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                  setState(() {
                                    isProcessing = false;
                                  });
                                  if (response == "Logged In") {
                                    return routeToHome(context);
                                  } else if (response == "Account not found") {
                                    var snackBar = SnackBar(
                                        content: Text("Account not found"));
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } else if (response ==
                                      "Incorrect password or missing values") {
                                    var snackBar = SnackBar(
                                        content: Text(
                                            "Incorrect password or missing values"));
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
