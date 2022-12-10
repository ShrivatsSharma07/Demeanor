import 'package:denamor/Screens/home_page.dart';
import 'package:denamor/Screens/login_page.dart';
import 'package:denamor/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // If snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {

          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamSnapshot) {
                // If Streamsnapshot has error
                if (streamSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${streamSnapshot.error}"),
                    ),
                  );
                }
                //Connection state active - Do the user login check inside the
                // if statement
                if (streamSnapshot.connectionState == ConnectionState.active){
                  //Get the User
                    Object? _user = streamSnapshot.data;

                    if(_user == null){
                      return LoginPage();
                    }
                    else{
                      return HomePage();
                    }

                }
                // Checking the Auth State
                return Scaffold(
                  body: Center(
                    child: Text(
                      "Checking Authentication...",
                      style: Constants.regularHeading,
                    ),
                  ),
                );
              }
          );
        }

        return Scaffold(
          body: Center(
            child: Text(
              "Initializing App",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
