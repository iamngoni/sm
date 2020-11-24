import 'package:flutter/material.dart';
import 'package:school_management/api/index.dart';

class Students extends StatefulWidget {
  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final _api = new API();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Students"),
      ),
      body: FutureBuilder(
        future: _api.getStudents(),
        builder: (context, snapshot) {
          while (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data["students"];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text(
                    "${data[index]["firstName"]} ${data[index]["lastName"]}"),
                trailing: GestureDetector(
                  onTap: () async {
                    var response = await _api.removeStudent(data[index]["_id"]);
                    if (response) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Students(),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
