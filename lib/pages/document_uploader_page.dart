import 'package:chatbot/services/doc_uploader/my_html_uploader.dart';
import 'package:chatbot/services/doc_uploader/my_pdf_uploader.dart';
import 'package:flutter/material.dart';

class DocumentUploaderPage extends StatefulWidget{

  @override
  State<DocumentUploaderPage> createState() => _DocumentUploaderPageState();

}

class _DocumentUploaderPageState extends State<DocumentUploaderPage>{

  Widget _selectedPage = Container();

  void _changePage(Widget page){
    setState(() {
      _selectedPage = page;
    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text("Document Uploader"),
      ),

      body: Row(
        children: [
          Expanded(
            flex: 5,  
            child: ListView(
              children: [
                ListTile(
                  title: const Text('P D F  U P L O A D E R'),
                  onTap: () => _changePage(const MyPdfUploader()),

                ),

                ListTile(
                  title: const Text('H T M L P A G E U P L O A D E R'),
                  onTap: () =>_changePage(MyHtmlUploader()),
                ),

              ],

            ),
            
          ),

          Container(
            width: 1.0,
            color: Colors.black,
          ),

          Expanded(
            flex: 3,
            child: _selectedPage,
          ),

        ],

      ),

    );

  }

}