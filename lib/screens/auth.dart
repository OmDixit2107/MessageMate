import 'dart:io';

import 'package:chatapp/widgets/userimg_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formkey = GlobalKey<FormState>();
  var _enteredemail = '';
  var _enteredpass = '';
  var _enteredusername = '';
  File? _selectedimg;
  var _isuploading = false;
  var _islogin = true;
  void _submit() async {
    final isvalid = _formkey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    if (!_islogin && _selectedimg == null) {
      //show error
      return;
    }
    _formkey.currentState!.save();

    try {
      setState(() {
        _isuploading = true;
      });
      if (_islogin) {
        final usercreds = await _firebase.signInWithEmailAndPassword(
          email: _enteredemail,
          password: _enteredpass,
        );
      } else {
        final usercreds = await _firebase.createUserWithEmailAndPassword(
          email: _enteredemail,
          password: _enteredpass,
        );
        final storageref =
            FirebaseStorage.instance.ref().child('user_images').child(
                  '${usercreds.user!.uid}.jpg',
                );
        await storageref.putFile(_selectedimg!);
        final imageurl = await storageref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercreds.user!.uid)
            .set(
          {
            'username': _enteredusername,
            'email': _enteredemail,
            'image_url': imageurl
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Auth Failed"),
        ),
      );
      setState(() {
        _isuploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 30, right: 30),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_islogin)
                            UserimgPicker(
                              onpickimg: (pickimg) {
                                _selectedimg = pickimg;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please Enter A Valid Email Address';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _enteredemail = val!;
                            },
                          ),
                          if (!_islogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Username",
                              ),
                              enableSuggestions: false,
                              validator: (val) {
                                if (val == null ||
                                    val.isEmpty ||
                                    val.trim().length < 4) {
                                  return 'Please add at least 4 letters';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _enteredusername = val!;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Please Enter A Password of atleast 6 characters';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _enteredpass = val!;
                            },
                            // autocorrect: false,
                            // textCapitalization: TextCapitalization.none,
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isuploading) const CircularProgressIndicator(),
                          if (!_isuploading)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 8, 237, 134)),
                              onPressed: _submit,
                              child: Text(_islogin ? "Log In" : 'Sign Up'),
                            ),
                          if (!_isuploading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _islogin = !_islogin;
                                });
                              },
                              child: Text(_islogin
                                  ? 'Create An Account'
                                  : 'I already have a account'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
