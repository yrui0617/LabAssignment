import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  Map<String,dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 224, 224),
      appBar: AppBar(
        title:
          Text("User Profile",style: TextStyle(fontSize: 24, color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 117, 145, 193),
        ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [    
            userData.isEmpty?
              const CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ):
            
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 117, 145, 193), // Border color
                  width: 7,          // Border thickness
                ),
              ),
              child:CircleAvatar(
                radius: 90,
                backgroundImage:
                    NetworkImage(userData['picture']['large']),
              ),
            ),
            
            const SizedBox(height: 10),
            Container(
              height: 280,
              width: 330,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userData.isEmpty?
                  const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ):
                  Padding(padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name   : ""${userData['name']['title']} ${userData['name']['first'] } ${userData['name']['last']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("Gender : ""${userData['gender']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("Email : ""${userData['email']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("Phone  : ""${userData['phone']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("Street  : ""${userData['location']['street']['number']} ${userData['location']['street']['name']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("City      : ""${userData['location']['city']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("State    : ""${userData['location']['state']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                        Text("Country  : ""${userData['location']['country']}",
                          style: const TextStyle(
                            fontSize: 18
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 117, 145, 193),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              onPressed: getUserProfile,
              child: const Text("Refresh",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> getUserProfile() async {
    try{
      final response = await http.get(Uri.parse(
          'https://randomuser.me/api/'));
        log(response.body.toString());

      if (response.statusCode == 200) {
        final Map<String,dynamic> data = json.decode(response.body);
        setState(() {
          userData = data['results'][0];
        });
      }
    }catch(e){
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching user data"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}