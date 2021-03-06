import 'package:TouristAssist/helper/helper_functions.dart';
import 'package:TouristAssist/pages/tourist_home_page.dart';
import 'package:TouristAssist/services/auth_service.dart';
import 'package:TouristAssist/shared/constants.dart';
import 'package:TouristAssist/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TouristSignUpPage extends StatefulWidget {

  final Function toggleView;
  TouristSignUpPage({this.toggleView});

  @override
  _TouristSignUpPageState createState() => _TouristSignUpPageState();
}

class _TouristSignUpPageState extends State<TouristSignUpPage> {

  TextEditingController _fullNameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passwordEditingController = new TextEditingController();
  TextEditingController _confirmPasswordEditingController = new TextEditingController();

  final AuthService _authService = new AuthService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _error = '';

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _authService.registerTouristWithEmailAndPassword(_fullNameEditingController.text, _emailEditingController.text, _passwordEditingController.text).then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(_emailEditingController.text);
          await HelperFunctions.saveUserNameSharedPreference(_fullNameEditingController.text);

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => TouristHomePage()), (Route<dynamic> route) => false);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TouristHomePage()));
        }
        else {
          setState(() {
            _error = 'Error while registering the user!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Get started as a Tourist", style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold)),
                    
                  SizedBox(height: 30.0),
                    
                  Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    
                  SizedBox(height: 20.0),
                    
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _fullNameEditingController,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.person, color: Colors.white)
                    ),
                    validator: (val) => val.isEmpty ? 'This field cannot be blank' : null
                  ),
                    
                  SizedBox(height: 15.0),
                    
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailEditingController,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.alternate_email, color: Colors.white)
                    ),
                    validator: (val) {
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
                    },
                  ),
                    
                  SizedBox(height: 15.0),
                    
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordEditingController,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock, color: Colors.white)
                    ),
                    validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
                    obscureText: true,
                  ),

                  SizedBox(height: 15.0),
                    
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _confirmPasswordEditingController,
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Confirm password',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                    ),
                    validator: (val) => val == _passwordEditingController.text ? null : 'Does not macth the password',
                    obscureText: true,
                  ),

                  SizedBox(height: 20.0),
                    
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        _onRegister();
                      }
                    ),
                  ),

                  SizedBox(height: 20.0),
                    
                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(color: Colors.lightBlueAccent),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),
                    
                  Text(_error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}