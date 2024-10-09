import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:notes_v1/json/json.dart';

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

  final db = Db('mongodb://admin:password@localhost:27017/user_account?authSource=admin');
  await db.open();
  final coll = db.collection('user');
  
  // final user = User.fromJson(body);
  final username = params['username'] ?? '__hello';
  final password = params['password'] ?? '__fello';

  final temp = await coll.find({
      'username':username,
      'password':password,
    }).toList();

  await db.close();

  if(temp.isNotEmpty ){
    return Response(body: temp[0]['notes'] == null ? 'empty' : temp[0]['notes'] as String);
  }

  return Response(body: 'Invalid');
}

Future<Response> update_notes(context) async{

  final request = context.request;
  final body = await request.json() as Map<String, dynamic>;
  // final params = request.uri.queryParameters;
  final db = Db('mongodb://admin:password@localhost:27017/user_account?authSource=admin');
  await db.open();
  final coll = db.collection('user');
  
  final user = User.fromJson(body);
  final username = user.username;
  final password = user.password;
  final notes = user.notes;
  // print(notes);

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