import 'package:flutter/material.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';
import 'package:school_management/views/admin/addclass.dart';
import 'package:school_management/views/admin/addstudent.dart';
import 'package:school_management/views/admin/addteacher.dart';
import 'package:school_management/views/admin/attendance.dart';
import 'package:school_management/views/admin/classes.dart';
import 'package:school_management/views/admin/students.dart';
import 'package:school_management/views/admin/teachers.dart';
import 'package:school_management/views/admin/viewattendance.dart';
import 'package:school_management/views/auth/login.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _api = new API();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("School Attendance Management"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: FutureBuilder(
                future: _api.accountDetails(),
                builder: (context, snapshot) {
                  while (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                    width: width(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data["firstName"],
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          snapshot.data["lastName"],
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                tileColor: Colors.grey.withOpacity(0.2),
                title: Text("About"),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                tileColor: Colors.grey.withOpacity(0.2),
                title: Text("Logout"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () async {
                  await _api.clearPreferences();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFecf0f4),
      body: SingleChildScrollView(
        child: Container(
          width: width(context),
          height: height(context),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Container(
                  width: width(context),
                  height: height(context) * 0.3,
                  child: Card(
                    elevation: 0,
                    color: Color(0xFFecf0f4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Admin Dashboard",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Welcome To The Admin",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: width(context),
                            height: height(context) * 0.2,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddClass(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width(context) * 0.3,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.class__outlined),
                                            Text("Add Class"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddTeacher(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width(context) * 0.3,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons
                                                .integration_instructions_outlined),
                                            Text("Add Teacher"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddStudent(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width(context) * 0.3,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.class__outlined),
                                            Text("Add Students"),
                                          ],
                                        ),
                                      ),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Container(
                  width: width(context),
                  height: height(context) * 0.3,
                  child: Card(
                    elevation: 0,
                    color: Color(0xFFecf0f4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "View",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: width(context),
                            height: height(context) * 0.2,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Classes(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width(context) * 0.3,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.class__outlined),
                                            Text("Classes"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Teachers(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width(context) * 0.3,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons
                                                .integration_instructions_outlined),
                                            Text("Teachers"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Students(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: width(context) * 0.3,
                                      child: Card(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.class__outlined),
                                            Text("Students"),
                                          ],
                                        ),
                                      ),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: Container(
                  width: width(context),
                  height: height(context) * 0.3,
                  child: Card(
                    elevation: 0,
                    color: Color(0xFFecf0f4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            width: width(context),
                            height: height(context) * 0.2,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Classes(),
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AttendanceRegister(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width(context) * 0.5,
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.app_registration,
                                                size: 40,
                                              ),
                                              Text("Mark Attendance"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Classes(),
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAttendance(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width(context) * 0.5,
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.how_to_reg,
                                                size: 40,
                                              ),
                                              Text("View Attendance"),
                                            ],
                                          ),
                                        ),
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
