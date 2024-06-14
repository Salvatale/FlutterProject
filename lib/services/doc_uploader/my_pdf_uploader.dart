import 'dart:convert';
import 'package:chatbot/components/my_textfield.dart';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/services/http/my_http.dart';
import 'package:chatbot/services/user/user_string_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class MyPdfUploader extends StatefulWidget {

  const MyPdfUploader({
    super.key,
  });

  @override
  State<MyPdfUploader> createState() => _MyPdfUploaderState(); 

}

class _MyPdfUploaderState extends State<MyPdfUploader>{

  
  final List<PlatformFile> _uploadedFiles = [];
  final TextEditingController _nameListController = TextEditingController();

  Future<void> _pickPDF(BuildContext context) async {

    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],

      );

      if (result != null) {
        setState(() {
          _uploadedFiles.addAll(result.files);
        });
      }
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

  void _processPdfs(BuildContext context) async{
    if(_uploadedFiles.isEmpty || _nameListController.text.isEmpty)
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text("Files or name field missing"),
        )
      );
      else{

        MyHtpp myHtpp = MyHtpp();

        try{

          String directoryName = _nameListController.text;
          _nameListController.clear();
          
          final response = await myHtpp.sendFiles(_uploadedFiles,directoryName);
          final responseData = await response.stream.bytesToString();
          Map<String,dynamic> decodedResponse = json.decode(responseData);
          showDialog(
            context: context, 
            builder: (context) => AlertDialog(
            title: Text(decodedResponse['message']),
            )
          );
          
          UserStringList userList = UserStringList();
          AuthService authService = AuthService();
          final userId = authService.getCurrentUserID();

          userList.addUserElement(userId, directoryName);

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

  }

  void _removeFile(int index){
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context){
  
    return Scaffold(

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              height: 1,
              color: Colors.black,
            ),
            
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () => _pickPDF(context),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(200, 50),
                  ),
                ),
                child: const Text(
                  "Load PDF files",
                  style: TextStyle(color: Colors.black),
                ),
                
              ),
            ),

            const SizedBox(height: 20,),

            Expanded(
              child: ListView.builder(

                itemCount: _uploadedFiles.length,  
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      
                      leading: const Icon(Icons.picture_as_pdf),
                      title: Text(_uploadedFiles[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeFile(index), 
                      ),
                    
                    ),
                  );
                },
                
              ),
            ),

            Container(
              height: 1,
              color: Colors.black,
            ),

            MyTextField(
              hintText: "Type your context name",
              obscureText: false,
              controller: _nameListController,
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () => _processPdfs(context),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(200, 50),
                  ),
                ),
                child: const Text(
                  "Process Pdfs",
                  style: TextStyle(color: Colors.black),
                ),
                
              ),
            ),


          ],

        ),

      ),

    );

  }

}