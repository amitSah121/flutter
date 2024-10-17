import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes_v1/helper_funcs/helper.dart';
import 'package:notes_v1/json/json.dart';
import 'package:pointycastle/export.dart';

import 'test.dart';

Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => get_notes(context),
    HttpMethod.post => update_notes(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> get_notes(context) async{
  final request = context.request;
  final params = request.uri.queryParameters;

  final db = Db(uri);
  await db.open();
  final coll = db.collection('user');
  
  // final user = User.fromJson(body);
  final username = params['username'] ?? '__hello';
  final password = params['password'] ?? '__fello';

  // print((username,password));

  final modulus = BigInt.parse(params['modulus'] as String);
  final exponent = BigInt.parse(params['exponent'] as String);
  final publicKey = RSAPublicKey(modulus, exponent);

  final temp = await coll.find({
      'username':username,
      'password':password,
    }).toList();

  await db.close();

  // print(temp);
  if(temp.isNotEmpty ){
    final message = temp[0]['notes'] == null ? 'empty' : temp[0]['notes'] as String;
    // print(message);
    final encryptedData = rsaEncrypt(message, publicKey, null);
    // print(encryptedData);
    return Response(body: encryptedData);
  }

  return Response(body: 'Invalid');
}

Future<Response> update_notes(context) async{

  final request = context.request;
  final body = await request.json() as Map<String, dynamic>;
  // final params = request.uri.queryParameters;
  final db = Db(uri);
  await db.open();
  final coll = db.collection('user');
  
  final message = body['data'].split("--") as List<String>;
  final uname = body['username'];
  List<String> temp_1 = [];
  for(int i=0 ; i<message.length ; i++){
    try{
      temp_1.add(rsaDecrypt(message[i], null, users_keys[uname]!.privateKey!));
    }catch (e){}
  }
  // print(temp_1.join());

  var user;
  try{
  user = User.fromJson(jsonDecode(temp_1.join()) as Map<String,dynamic>);
  }catch (e){
    return Response(body:"Invalid");
  }
  final username = user.username;
  final password = user.password;
  final notes = user.notes;
  // print((notes,username)); 
  


  // return Response(body: "hello");
  final temp = await coll.find({
      'username':username,
      'password':password,
    }).toList();

  if(temp.isNotEmpty){
    await coll.updateOne(where.eq('_id', temp[0]['_id']),
     modify.set('notes', jsonEncode(notes!.toJson())),);
    // print(notes!.toJson());
    await db.close();
    return Response(body: 'updated');
  }

  await db.close();

  return Response(body: 'invalid');
}