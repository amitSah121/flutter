import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes_v1/helper_funcs/helper.dart';
import 'package:notes_v1/json/json.dart';


Future<Response> onRequest(RequestContext context){
  return switch (context.request.method) {
    HttpMethod.get => login(context),
    HttpMethod.post => register(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> login(context) async{
  final request = context.request;
  final params = request.uri.queryParameters;

  final db = Db(uri);
  await db.open();
  final coll = db.collection('user');
  
  
  final username = params['username'] ?? '__hello';
  final password = params['password'] ?? '__fello';

  // List<Map<String,dynamic>> 
  final temp = await coll.find({
      'username':username,
      'password':password,
    }).toList();

  if(temp.isNotEmpty ){
    await db.close();
    return Response(body: temp[0]['_id'].toString());
  }else{
     
    final temp_1 = await coll.find({
      'username':username,
    }).toList();

    if(temp_1.isNotEmpty && password == '__fello'){
      await db.close();
      return Response(body: 'Username already exists.');
    }

    await db.close();
    return Response(body: 'invalid');
  }
}

Future<Response> register(context)async{
  final request = context.request;
  final body = await request.json() as Map<String, dynamic>;
  // final params = request.uri.queryParameters;
  final db = Db(uri);
  await db.open();
  final coll = db.collection('user');
  
  final user = User.fromJson(body);
  final username = user.username;
  final password = user.password;


  final List<dynamic> temp_1 = await coll.find({'username':username}).toList();

  if(temp_1.isEmpty ){
    await coll.insertOne(
      {'username': username, 'password': password,'notes':'{"note":{"hierarchy": {"index": [0],"type": "text","content": ""}}}'},
    );
    await db.close();
    return Response(body: 'log_in');
  }else{
    await db.close();
    return Response(body: 'invalid');
  }
}