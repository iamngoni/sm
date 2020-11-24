import 'package:flutter/material.dart';
import 'package:school_management/api/index.dart';
import 'package:school_management/statics/values.dart';

class ViewAttendance extends StatefulWidget {
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  final _api = new API();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's attendance"),
      ),
      body: Container(
        height: height(context),
        width: width(context),
        child: FutureBuilder(
          future: _api.getAttendance(),
          builder: (context, snapshot) {
            while (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var attendance = snapshot.data["attendance"];
            List attendees = attendance["attendees"];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date: ${attendance["date"]} (Present)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    width: width(context),
                    height: height(context) * 0.8,
                    child: ListView.builder(
                      itemCount: attendees.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),
                          title: Text(attendees[index]["firstName"]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
