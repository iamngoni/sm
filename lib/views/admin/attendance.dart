import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';

class AttendanceRegister extends StatefulWidget {
  @override
  _AttendanceRegisterState createState() => _AttendanceRegisterState();
}

class _AttendanceRegisterState extends State<AttendanceRegister> {
  final _api = new API();
  List _students = [];
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance"),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () async {
            setState(() {
              isProcessing = true;
            });
            var response = await _api.markRegister(_students);
            setState(() {
              isProcessing = false;
            });
            if (response == "Done") {
              var snackbar = SnackBar(content: Text("Done"));
              Scaffold.of(context).showSnackBar(snackbar);
            }
          },
        ),
      ),
      body: Builder(
        builder: (context) => ModalProgressHUD(
          inAsyncCall: isProcessing,
          child: Container(
            height: height(context),
            width: width(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Search student",
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  FutureBuilder(
                    future: _api.getClass(),
                    builder: (context, snapshot) {
                      while (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return FutureBuilder(
                        future: _api.getStudentsByClass(snapshot.data),
                        builder: (context, snapshot) {
                          while (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List data = snapshot.data["students"];
                          _students.forEach((element) {
                            data.remove(element);
                          });
                          return Container(
                            width: width(context),
                            height: height(context) * 0.4,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    "${data[index]["firstName"]}",
                                  ),
                                  trailing: Container(
                                    color: Colors.red,
                                    child: MaterialButton(
                                      child: Text(
                                        "Mark as absent",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (!_students
                                              .contains(data[index])) {
                                            _students.add(data[index]);
                                          }
                                          data.remove(data[index]);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Text(
                    "Absent Students",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  Container(
                    width: width(context),
                    height: height(context) * 0.5,
                    child: ListView.builder(
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            "${_students[index]["firstName"]}",
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {
                                _students.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
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
