import 'package:chatbot/components/my_button.dart';
import 'package:chatbot/components/my_dropdown_menu.dart';
import 'package:chatbot/components/my_textfield.dart';
import 'package:chatbot/services/http/my_http.dart';
import 'package:flutter/material.dart';


class MyMailChat extends StatefulWidget{

  const MyMailChat({super.key});

  @override
  State<MyMailChat> createState() => _MyMailChatState();

}

class _MyMailChatState extends State<MyMailChat> {

  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  String selectedContext = '';

  void selectContext(String context){
    setState(() {
      selectedContext = context;
    });
  }

  void sendMail(BuildContext context) async{

    MyHtpp myHtpp = MyHtpp();

    String mailText = _mailController.text;
    String questionText = _questionController.text;

    _mailController.clear();
    _questionController.clear();

    try{
      await myHtpp.mailPost(questionText, mailText);
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
        title: const Text("MailChatbot"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      backgroundColor: Theme.of(context).colorScheme.secondary,

      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
              
                  //logo Icon
                  const Icon(
                    Icons.email,
                    size: 60,
                  ),
              
                  const SizedBox(height: 30,),
              
                  //text
                  Text(
                    "Welcome, insert email and question, you will receive the answer by mail",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
              
                  const SizedBox(height: 30,),
              
                  // email textfield
                  MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: _mailController,
                  ),
              
                  const SizedBox(height: 10,),
              
                  //question textfield
                  MyTextField(
                    hintText: "Question",
                    obscureText: false,
                    controller: _questionController
                  ),
              
                  const SizedBox(height: 25,),
              
                  // send mail button
                  MyButton( 
                    text: "Enter",
                    onTap: () => sendMail(context))
              
                ],
                
              ),
            ),

            Container(
              width: 1.0,
              color: Colors.black,
            ),

            Expanded(
              flex: 2,
              child: MyDropdownMenu(selectItem: selectContext,),
            
            ),

          ],
        ),
        
      ),

    );

  }

}