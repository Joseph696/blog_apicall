import 'dart:convert';
import 'dart:io';

import 'package:blog_apicall/Model_class/user_model.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class UserDropDown extends StatefulWidget {
  const UserDropDown({super.key});

  @override
  State<UserDropDown> createState() => _UserDropDownState();
}

class _UserDropDownState extends State<UserDropDown> {
  Future<List<UserModel>> getPost() async {
    try {
      final res = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      final body = jsonDecode(res.body) as List;
      if (res.statusCode == 200) {
        return body.map(
          (e) {
            final map = e as Map<String, dynamic>;
            return UserModel(
                id: map["id"],
                name: map['name'],
                username: map["username"],
                email: map["email"],
                phone: map["phone"],
                website: map["website"],
              
               );
          },
        ).toList();
      }
    } on SocketException {
      throw Exception('Network failed');
    }
    throw Exception('Fetch data error');
  }

  var selectedValue;
  @override

  //   final res =
  //       await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<List<UserModel>>(
                future: getPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButton(
                      
                      elevation: 5,
                      alignment: Alignment.center,
                      //focusColor: Colors.white,
                        value: selectedValue,
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        hint: const Text("Usernames",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w700),),
                        items: snapshot.data!.map((e) {
                          return DropdownMenuItem(
                            value: e..toString(),
                            child: Text(e.username.toString()
                                // Display the title in DropdownMenuItem
                                ),
                          );
                        }).toList(), // Change this to toList()
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        });
                  } else if (snapshot.hasError) {
                    // Add this block for error handling
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}
