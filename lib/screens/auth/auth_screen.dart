
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth/auth_logo.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formmkey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isLoading = false;

  String firstName = "";
  String lastName = "";
  String phone = "";
  String email = "";
  String password = "";




  

 void authentication({
   required String userfirstName,
   required String userlastName,
   required String userPhone,
   required String userEmail,
   required String userPassword,
 }) async {
   print([userfirstName, userlastName, userPhone, userEmail, userPassword]);

   final auth = FirebaseAuth.instance;
   final db = FirebaseFirestore.instance;
   UserCredential result;

   try {
     if (isLogin) {
       result = await auth.signInWithEmailAndPassword(
           email: userEmail, password: userlastName);
     } else {
       result = await auth.createUserWithEmailAndPassword(
           email: userEmail, password: userPassword);

       final user = result.user!;
       await db.collection("users").doc(user.uid).set({
         "email": user.email,
         "firstName": userfirstName,
         "lastName": userlastName,
         "phone": userPhone,
         "imageUrl": "",
         "createdAt": DateTime.now().toString(),
         "updatedAt": DateTime.now().toString()
       });
     }
   } on FirebaseException catch (e) {
     print(e.message);
   } catch (e) {
     print(e);
   }
 }

  void _submit() {
  

   if (!_formmkey.currentState!.validate()) {
     return;
   }
   _formmkey.currentState!.save();
   authentication(
     userfirstName: firstName,
      userlastName: lastName,
       userPhone: phone, 
       userEmail: email, 
       userPassword: password);
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formmkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLogin
                      ? AuthLogo()
                      : Container(
                          padding: EdgeInsets.only(top: 30, bottom: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Please complete this form",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                  if (!isLogin)
                    Container(
                      margin: EdgeInsets.only(bottom: 6),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Firt Name",
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 3) {
                                      return "Please input a valid firstname...";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    firstName = value!.trim();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Last Name",
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 3) {
                                      return "Please input a valid lastname...";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    lastName = value!.trim();
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Phone",
                                icon: Icon(
                                  Icons.phone_iphone,
                                  color: Colors.grey,
                                )),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  int.tryParse(value) == null ||
                                  value.length < 10) {
                                return "Please input a valid phone...";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value!.trim();
                            },
                          ),
                        ],
                      ),
                    ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        )),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please input a valid email address...";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!.trim();
                    },
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "Please input a valid password...";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!.trim();
                    },
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text(isLogin
                            ? "Don't have an account yet?"
                            : "Already have an account?"),
                        SizedBox(height: 5),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin ? "Sign Up" : "Login",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 30 : 18),
        child: ElevatedButton(
          onPressed: ()=>_submit(),
          child: Text(
            isLogin ? "Login" : "Sign Up",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
