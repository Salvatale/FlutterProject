import 'package:chatbot/components/my_chat.dart';
import 'package:chatbot/services/doc_uploader/my_pdf_uploader.dart';
import 'package:flutter/material.dart';

class PdfPageBody extends StatefulWidget{

  const PdfPageBody({super.key});

  @override
  State<PdfPageBody> createState() => _PdfPageBodyState();

}

class _PdfPageBodyState extends State<PdfPageBody>{

  String selectedItem = '';

  void selectItem(String item){
    setState(() {
      selectedItem = item;
    });
  }
  
  @override
  Widget build(BuildContext context){

    return Scaffold(

      body: Center(

        child: Row(
          children: [

            Expanded(
              flex: 8,
              child: const MyChatBot()
            ),

            Container(
              width: 1,
              color: Colors.black,
            ),

            Expanded(
              flex: 2,
              child: const MyPdfUploader(),
            )
          ],

        ),
      ),


    );

  }

}