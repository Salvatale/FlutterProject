import 'package:chatbot/components/my_choice_button.dart';
import 'package:chatbot/components/my_drawer.dart';
import 'package:chatbot/pages/chatbot_page.dart';
import 'package:chatbot/pages/document_uploader_page.dart';
import 'package:chatbot/pages/mail_chatbot_page.dart';
import 'package:chatbot/pages/speechbot_page.dart';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/services/user/user_string_list.dart';
import 'package:flutter/material.dart';

class ChoicePage extends StatefulWidget{
    
  const ChoicePage({
    super.key,    
  });

  @override
  State<ChoicePage> createState() => _ChoicePageState();

}

class _ChoicePageState extends State<ChoicePage>{

  @override
  void initState() {
    super.initState();
    initList();

  }

  void initList() async{

    try{
      await UserStringList.initializeUserList(AuthService().getCurrentUserID());
    }
    catch(e){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        )
      
      );
    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(

        title: const Text("Main Page"),

      ),

      drawer: const MyDrawer(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            MyChoiceButton(
              text: "C H A T B O T", 
              page: const HomePage(), 
              icon: const Icon(Icons.chat, size: 30.0,),
            ),

            MyChoiceButton(
              text: "M A I L B O T", 
              page: MailChatbotPage(), 
              icon: const Icon(Icons.email, size: 30.0,),
            ),

            MyChoiceButton(
              text: "D O C  U P L O A D E R", 
              page: DocumentUploaderPage(), 
              icon: const Icon(Icons.upload_file, size: 30.0,),
            ),

            MyChoiceButton(
              text: "S P E E C H B O T", 
              page: SpeechBotPage(), 
              icon: const Icon(Icons.mic, size: 30.0,),
            ),

          ],
        ),

      ),

    );

  }

}