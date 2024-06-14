import 'package:chatbot/components/my_chat.dart';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {

  const HomePage({
    super.key,
  });

  void logout(){
    // get auth service

    final _auth = AuthService();

    _auth.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        title: const Text("Chatbot"),

        actions: [

          //logout button
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout)
          ),

        ],

      ),

      body: const MyChatBot(),
    );
  }

}