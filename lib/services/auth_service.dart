// import 'dart:html';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   //Google Sign In
//   signInWithGoogle() async {
//     //begin interactive signin process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().singIn();
//     //obtain auth details form request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//     //create a new creditials for uuser
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );

//     //finally, lets sign in
//     return await FirebaseAuth.instance,signInWithCredential(credential);
//   }
// }
   