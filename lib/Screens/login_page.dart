import 'package:denamor/Screens/register_page.dart';
import 'package:denamor/Widgets/custom_btn.dart';
import 'package:denamor/Widgets/custom_input.dart';
import 'package:denamor/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close Dialog"),
              )
            ],
          );

        }
    );
  }

  Future<String?> _loginAccount() async{
    try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _loginEmail, password: _loginPassword);
        return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak password') {
        return 'The password provided is too weak';
      }else if (e.code == 'email-already-in-use') {
        return 'The account already exists for the email';
      }
      return e.message;
    }catch(e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    setState(() {
      _loginFormLoading = true;
    });
    String? _loginFeedback = await _loginAccount();
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);


      setState(() {
        _loginFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool _loginFormLoading = false;

  String _loginEmail = "";
  String _loginPassword = "";


  FocusNode? _passwordFocusNode;
  FocusNode? _confirmpasswordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _confirmpasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode?.dispose();
    _confirmpasswordFocusNode?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child : Container(
            width: double.infinity,
             child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                   padding: EdgeInsets.only(
                     top: 24.0,
                   ),
                   child: Text("Welcome to Denamor \n Please Login to your account",
                   textAlign: TextAlign.center,
                     style: Constants.boldHeading,
                   ),
                 ),
                 Column(
                   children: [
                     CustomInput(
                       hintText: "Email",
                       onChanged: (value) {
                         _loginEmail = value;
                       },
                       onSubmitted: (value) {
                         _passwordFocusNode?.requestFocus();
                       },
                       textInputAction: TextInputAction.next,
                     ),
                     CustomInput(
                       hintText: "Password",
                       onChanged: (value) {
                         _loginPassword = value;
                       },
                       onSubmitted: (value) {
                         _submitForm();
                       },
                       textInputAction: TextInputAction.next,
                       focusNode: _passwordFocusNode,
                       isPasswordField: true,
                     ),
                     CustomBtn(text: "Login",
                       onPressed: () {
                         _submitForm();
                         setState(() {
                           _loginFormLoading = true;
                         });
                       },
                       isLoading: _loginFormLoading,
                     ),
                   ],
                 ),
                 Padding(
                   padding: const EdgeInsets.only(
                     bottom: 16.0,
                   ),
                   child: CustomBtn(
                     text: "Create New Account",
                     onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RegisterPage()
                      ),
                      );
                     },
                     outlineBtn: true,
                   ),
                 ),
        ],
      ),
      )
      )
    );

  }
}
