import 'package:denamor/Widgets/custom_btn.dart';
import 'package:denamor/Widgets/custom_input.dart';
import 'package:denamor/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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


  Future<String?> _createAccount() async{
    try{
      if (_registerPassword == _registerConfirmPassword) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _registerEmail, password: _registerPassword);
        return null;
      }
      else {
        return 'Please enter the correct password in confirm password field';
      }
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
      _registerFormLoading = true;
    });
    String? _crateAccountFeedback = await _createAccount();
    if (_crateAccountFeedback != null) {
      _alertDialogBuilder(_crateAccountFeedback);


      setState(() {
        _registerFormLoading = false;
      });
    } else {
        Navigator.pop(context);
    }
  }

  bool _registerFormLoading = false;

  String _registerEmail = "";
  String _registerPassword = "";
  String _registerConfirmPassword = "";

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
                    child: Text("Create a New Account",
                      textAlign: TextAlign.center,
                      style: Constants.boldHeading,
                    ),
                  ),
                  Column(
                    children: [
                      CustomInput(
                        hintText: "Email",
                        onChanged: (value) {
                          _registerEmail = value;
                        },
                        onSubmitted: (value) {
                          _passwordFocusNode?.requestFocus();
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      CustomInput(
                        hintText: "Password",
                        onChanged: (value) {
                          _registerPassword = value;
                        },
                        onSubmitted: (value) {
                          _confirmpasswordFocusNode?.requestFocus();
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordFocusNode,
                        isPasswordField: true,
                      ),
                      CustomInput(
                        hintText: "Confirm Password",
                        onChanged: (value) {
                          _registerConfirmPassword = value;
                        },
                        focusNode: _confirmpasswordFocusNode,
                        isPasswordField: true,
                        onSubmitted: (value) {
                          _submitForm();
                        },
                      ),
                      CustomBtn(text: "Create New Account",
                        onPressed: () {
                        _submitForm();
                          setState(() {
                            _registerFormLoading = true;
                          });
                        },
                        isLoading: _registerFormLoading,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: CustomBtn(
                      text: "Back to Login",
                      onPressed: () {
                        Navigator.pop(context);
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
