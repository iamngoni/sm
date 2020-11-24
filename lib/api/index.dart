import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final _server = "https://xyz-student.herokuapp.com/api";
  login(String email, String password) async {
    var response;
    try {
      response = await http.post(
        "$_server/login",
        body: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        await preferences(json.decode(response.body)["account"]);
        return "Logged In";
      } else if (response.statusCode == 404) {
        return "Account not found";
      } else if (response.statusCode == 422) {
        return "Incorrect password or missing values";
      }
    } catch (e) {
      print(e);
    }
  }

  preferences(Map<String, dynamic> info) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("firstName", info["firstName"]);
    prefs.setString("lastName", info["lastName"]);
    prefs.setString("schoolId", info["schoolId"]);
    prefs.setString("email", info["email"]);
    prefs.setString("accountType", info["accountType"]);
    if (info["accountType"] == "teacher") {
      prefs.setString("class", info["clas"]);
    }
    prefs.setString("access_token", info["token"]);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("access_token");
    return token;
  }

  Future<String> getClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var clas = prefs.getString("class");
    return clas;
  }

  Future<String> getAccountType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accountType = prefs.getString("accountType");
    return accountType;
  }

  clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("firstName", null);
    prefs.setString("lastName", null);
    prefs.setString("schoolId", null);
    prefs.setString("email", null);
    prefs.setString("accountType", null);
    prefs.setString("access_token", null);
    prefs.setString("class", null);
  }

  Future<Map<String, dynamic>> accountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      "firstName": prefs.getString("firstName"),
      "lastName": prefs.getString("lastName"),
      "accountType": prefs.getString("accountType"),
      "schoolId": prefs.getString("schoolId"),
      "email": prefs.getString("email")
    };
  }

  addClass(String name) async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.post("$_server/addclass",
          body: {"name": name}, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 201) {
        return "Saved";
      } else if (response.statusCode == 422) {
        return "Not saved. Try again";
      } else if (response.statusCode == 400) {
        return "Class exists already";
      }
    } catch (e) {
      return "Server error";
    }
  }

  saveTeacher(String firstName, String lastName, String email, String clas,
      String password) async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.post("$_server/signup", body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "clas": clas,
        "password": password,
        "schoolId": "TEACHER",
        "accountType": "teacher"
      }, headers: {
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 201) {
        return "Saved";
      } else if (response.statusCode == 400) {
        return "Account exists";
      } else if (response.statusCode == 422) {
        return "Could not save teacher. Try again";
      }
    } catch (e) {
      return "Server error";
    }
  }

  saveStudent(String firstName, String lastName, String email, String studentId,
      String clas, String password) async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.post("$_server/signup", body: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "clas": clas,
        "password": password,
        "schoolId": studentId,
        "accountType": "student"
      }, headers: {
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 201) {
        return "Saved";
      } else if (response.statusCode == 400) {
        return "Account exists";
      } else if (response.statusCode == 422) {
        return "Could not save student. Try again";
      }
    } catch (e) {
      return "Server error";
    }
  }

  getClasses() async {
    var response;
    String token = await this.getToken();
    try {
      response = await http
          .get("$_server/classes", headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  getStudents() async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.get("$_server/students",
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  getStudentsByClass(String clas) async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.get("$_server/students/class/$clas",
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  getTeachers() async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.get("$_server/teachers",
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  removeStudent(String id) async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.get("$_server/student/$id/delete",
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  markRegister(List absentStudents) async {
    var list = absentStudents.map((e) => e["_id"]).toSet();
    absentStudents.retainWhere((x) => list.remove(x["_id"]));
    String token = await this.getToken();
    String clas = await this.getClass();

    var allStudents = await this.getStudentsByClass(clas);
    List students = allStudents["students"];
    for (int i = 0; i < students.length; i++) {
      for (int k = 0; k < absentStudents.length; k++) {
        if (students[i]["_id"] == absentStudents[k]["_id"]) {
          students.removeAt(i);
        }
      }
    }

    students.forEach((student) async {
      var response;
      try {
        response = await http.post("$_server/attendance",
            body: {"attendee": student["_id"], "class": student["clas"]},
            headers: {"Authorization": "Bearer $token"});
      } catch (e) {
        print(e);
      }
    });
    return "Done";
  }

  getAttendance() async {
    var response;
    String token = await this.getToken();
    String clas = await this.getClass();
    try {
      response = await http.get("$_server/attendance/view/$clas",
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  getAttendanceDetails() async {
    var response;
    String token = await this.getToken();
    try {
      response = await http.get("$_server/student/attendance",
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
