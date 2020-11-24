import 'package:flutter/material.dart';
import 'package:localregex/localregex.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _key = GlobalKey<FormState>();
  final firstNameController = new TextEditingController();
  final lastNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final classController = new TextEditingController();
  final schoolIdController = new TextEditingController();
  final passwordController = new TextEditingController();
  final _api = new API();
  final localregex = new LocalRegex();
  var _value;
  bool isProcessing = false;

  @override
  void initState() {
    var data = _api.getClasses();
    super.initState();
  }

  generateList(classes) {
    List<DropdownMenuItem<dynamic>> _fields = [];
    for (int i = 0; i < classes.length; i++) {
      _fields.add(
        DropdownMenuItem(
          child: Text(
            classes[i]["name"],
          ),
          value: classes[i]["name"],
        ),
      );
    }
    return _fields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Teacher"),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: isProcessing,
            child: Container(
              height: height(context),
              width: width(context),
              child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: "First Name",
                          ),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "First Name cannot be empty";
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: "Last Name",
                          ),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Last Name cannot be empty";
                            }
                          },
                        ),
                      ),
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
                              return "Email Address cannot be empty";
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
                          controller: schoolIdController,
                          decoration: InputDecoration(
                            labelText: "School ID",
                          ),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "School ID cannot be empty";
                            }
                          },
                        ),
                      ),
                      FutureBuilder(
                        future: _api.getClasses(),
                        builder: (context, snapshot) {
                          while (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          var data = snapshot.data["classes"];
                          _value = data[0]["name"];
                          return DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Class/Course",
                            ),
                            value: _value,
                            items: generateList(data),
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
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
                              "Save Student",
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
                                var response = await _api.saveStudent(
                                  firstNameController.text,
                                  lastNameController.text,
                                  emailController.text,
                                  schoolIdController.text,
                                  _value,
                                  passwordController.text,
                                );
                                setState(() {
                                  isProcessing = false;
                                });
                                if (response == "Saved") {
                                  var snackbar = SnackBar(
                                    content: Text("Saved"),
                                  );
                                  Scaffold.of(context).showSnackBar(snackbar);
                                } else if (response == "Account exists") {
                                  var snackbar = SnackBar(
                                    content: Text("Account exists"),
                                  );
                                  Scaffold.of(context).showSnackBar(snackbar);
                                } else if (response ==
                                    "Could not save student. Try again") {
                                  var snackbar = SnackBar(
                                    content: Text(
                                        "Could not save student. Try again"),
                                  );
                                  Scaffold.of(context).showSnackBar(snackbar);
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
