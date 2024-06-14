import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {

  const MyDrawer({
    super.key,
  });

  void logout(){
    // get auth service

    final _auth = AuthService();

    _auth.signOut();

  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Column(
            children: [
              //logo

              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 64,
                  ),
                ),
              ),


              // home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                  },
                
                ),
              ),


              //settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                 
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {

                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),

                      )
                    
                    );

                  },
                
                ),
              ),


            // //MailChatbot list tile
            //   Padding(
            //     padding: const EdgeInsets.only(left: 25.0),
            //     child: ListTile(
                 
            //       title: const Text("M A I L  C H A T B O T"),
            //       leading: const Icon(Icons.mail),
            //       onTap: () {

            //         Navigator.pop(context);

            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => MailChatbotPage(),

            //           )
                    
            //         );

            //       },
                
            //     ),
            //   ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 25.0),
              //   child: ListTile(
                 
              //     title: const Text("D O C  C H A T B O T"),
              //     leading: const Icon(Icons.insert_drive_file),
              //     onTap: () {

              //       Navigator.pop(context);

              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const DocumentChatbotPage(),

              //         )
                    
              //       );

              //     },
                
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 25.0),
              //   child: ListTile(
                 
              //     title: const Text("S P E E C H B O T"),
              //     leading: const Icon(Icons.headset),
              //     onTap: () {

              //       Navigator.pop(context);

              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => SpeechBotPage(),

              //         )
                    
              //       );

              //     },
                
              //   ),
              // ),
            ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 25.0),
            child: ListTile(
            
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            
            ),
          ),


        ],
      ),
    );
  }
}