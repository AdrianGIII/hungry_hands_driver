import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  //Sign in with Google
  signInWithGoogle() async{
    //begin process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    //obtaining authentication details upon request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //Create new credentials for user upon request
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}