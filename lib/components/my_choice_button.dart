import 'package:flutter/material.dart';

class MyChoiceButton extends StatelessWidget {
  final String text;
  final Widget page;
  final Icon icon;

  const MyChoiceButton({
    super.key,
    required this.text,
    required this.page,
    required this.icon,
  });

  @override
  Widget build(BuildContext context){

    return Padding(
      
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding : MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),  
          ),

          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),

        ),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => page),
          );
        }, 
        icon: icon, 
        label: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
        
      ),
    
    
    );

  }
}