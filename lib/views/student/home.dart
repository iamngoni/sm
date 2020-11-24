import 'package:flutter/material.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';
import 'package:school_management/views/auth/login.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
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
      body: Container(
        height: height(context),
        width: width(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FutureBuilder(
                future: _api.getAttendanceDetails(),
                builder: (context, snapshot) {
                  while (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data["details"];
                  return Container(
                    height: height(context) * 0.8,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.arrow_forward_rounded),
                          title: Text(
                            "Date: ${data[index]["date"]}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${data[index]["status"]}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
