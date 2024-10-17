import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:notes_v1/constants.dart';
import 'dart:convert';
import 'package:notes_v1/provider.dart';
import 'package:provider/provider.dart';

Future<String> getData(username, password) async {
  try {
    var newpass = sha256.convert(utf8.encode(password.toString()));
    var url = Uri.parse(getAuthConstant(username, newpass.toString()));
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // print(newpass);
      // print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'invalid';
  }
}

// Future<String> getNotes(username, password) async {
//   try {
//     var newpass = sha256.convert(utf8.encode(password.toString()));
//     var url = Uri.parse('http://localhost:8080/notes?username=$username&password=${newpass.toString()}');
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       // print(newpass);
//       return response.body;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     return 'Error: $e';
//   }
// }


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  
  

  // Future<>

  @override
  Widget build(BuildContext context) {
    // var temp = getData(Provider.of<CustomProvider>(context).username,Provider.of<CustomProvider>(context).password);
    // if(temp != 'invalid'){
    //   Navigator.pushNamed(context, "/notes");
    // }

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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
                          try{
                            final val = await getData(username.text, password.text);
                          // use the object id provided by val
                          // print(val);
                            if(val != "invalid"){
                              Future.microtask(() async{
                                final myModel = Provider.of<CustomProvider>(context, listen: false);
                                await myModel.set_auth(username.text, password.text);
                              });
                              Navigator.pushNamed(context, "/notes");
                            }
                          }catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Incorrect Username or password")));
                            print(e);
                          }
                            
                        }
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 64,),
                    Row(
                      children: [
                        const Text("Not registered yet!",
                        style: TextStyle(fontSize: 16),),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
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
