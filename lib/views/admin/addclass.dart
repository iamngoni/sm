import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _key = GlobalKey<FormState>();
  final nameController = new TextEditingController();
  final _api = new API();
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Class"),
      ),
      body: Builder(
        builder: (context) => ModalProgressHUD(
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
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Class Name",
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        width: width(context),
                        color: Colors.blue,
                        child: MaterialButton(
                          child: Text(
                            "Save",
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
                              var response =
                                  await _api.addClass(nameController.text);
                              setState(() {
                                isProcessing = false;
                              });
                              if (response == "Saved") {
                                var snackbar = SnackBar(
                                  content: Text("Saved"),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
                              } else if (response == "Not saved. Try again") {
                                var snackbar = SnackBar(
                                  content: Text("Not saved. Try again."),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
                              } else if (response == "Class exists already") {
                                var snackbar = SnackBar(
                                  content: Text("Class exists already"),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
                              } else {}
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
    );
  }
}
