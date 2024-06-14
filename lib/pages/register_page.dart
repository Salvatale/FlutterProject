import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/components/my_button.dart';
import 'package:chatbot/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPController = TextEditingController();
  final void Function()? onTap;


  RegisterPage({
    super.key,
    required this.onTap
  });

  //register method
  void register(BuildContext context) async{
    //get auth service
    final _auth = AuthService();

    if(_pwController.text == _confirmPController.text){
      try{
        await _auth.signUpWithEmailPassword(_emailController.text, _pwController.text);
      } catch(e){
        showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        )
      
        );
      }
    }
    else {
      showDialog(
        context: context, 
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        )
      
      );
    }

    // final userId = _auth.getCurrentUserID();
    // try{
    //   await UserStringList.createUserList(userId);

    // }
    // catch(e){
    //   showDialog(
    //     context: context, 
    //     builder: (context) => AlertDialog(
    //       title: Text(e.toString()),
    //     )
      
    //   );
    // }

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            //Welcomeback message
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                ),

              ),

            const SizedBox(height: 25),

            //email textfield
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            //password textfield
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 10),

            MyTextField(
              hintText: "Confirm password", 
              obscureText: true, 
              controller: _confirmPController,
            ),

            const SizedBox(height: 25),
            

            //login button
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(height: 25),

            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: onTap,
                  child: const Text("Login now", style: TextStyle(fontWeight: FontWeight.bold),))
              ],
            ),



          ],
        )
      )
    );
  }

}