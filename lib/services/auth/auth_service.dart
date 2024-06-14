import 'package:firebase_auth/firebase_auth.dart';

class AuthService {


  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in
  Future<UserCredential> signInWithEmailPassword(String email,password) async{

    try{

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;

    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }

  }
  // sign up
  Future<UserCredential> signUpWithEmailPassword( String email, password) async {

    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }

    

  }


  // sign out
  Future<void> signOut() async {

    return await _auth.signOut();

  }

  String getCurrentUserID(){

    User? user = _auth.currentUser;

    if(user != null){
      return user.uid;
    }
    else{
      throw Exception("User not logged in");
    }

  }
  





}