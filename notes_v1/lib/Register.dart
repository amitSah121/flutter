import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:notes_v1/constants.dart';

Future<String> getData(username, password) async {
  try {
    var newpass = sha256.convert(utf8.encode(password));
    // print(newpass.toString());
    var topass = {'username':username,'password':newpass.toString()};
    var url = Uri.parse(registerUrl);
    var response = await http.post(
      url,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(topass)
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'Error: $e';
  }
}


class Register extends StatefulWidget{
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>{

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();


  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext content){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Get Go",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Image(
              image: const AssetImage("assets/images/note.jpg"),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              ),
            ),
            const SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: username,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.length < 3) {
                          return 'Name must be at least 3 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: password,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,  // Hides the text
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: confirm_password,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,  // Hides the text
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }else if(value != password.text){
                          return 'Password and confirm password do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
                          try{
                            final val = await getData(username.text, password.text);
                          // use the object id provided by val
                            print(val);
                            Navigator.pushNamed(context, "/signin");
                          }catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Incorrect Username or password")));
                            print(e);
                          }
                            
                        }
                      },
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 64,),
                    Row(
                      children: [
                        const Text("Already signed up!",
                        style: TextStyle(fontSize: 16),),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signin');
                          },
                          child: const Text(
                            "Click Here",
                            style: TextStyle(color: Colors.blue, fontSize: 16)
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }
}