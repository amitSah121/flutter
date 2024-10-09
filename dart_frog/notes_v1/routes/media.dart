import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => get_image(context),
    HttpMethod.post => post_image(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}


Future<Response> get_image(RequestContext context) async{
  final request = context.request;
  final params = request.uri.queryParameters;

  final db = Db('mongodb://admin:password@localhost:27017/user_account?authSource=admin');
  await db.open();
  final coll = db.collection('user');
  

  final username = params['username'] ?? '__hello';
  final password = params['password'] ?? '__fello';
  final file_name = params['photo'] ?? '__jello';

  final List<dynamic> temp_1 = await coll.find({'username':username,'password':password}).toList();
  await db.close();

  if(temp_1.isEmpty){
    return Response(body: "invalid");
  }

  if(file_name != '__jello'){
    final file = File('./images/$file_name');
    if (!await file.exists()) {
      return Response(statusCode: HttpStatus.notFound, body: 'Image not found');
    }

    final imageBytes = await file.readAsBytes();

    return Response.bytes(
    body: imageBytes,
    headers: {'Content-Type': 'image/png'}, // Adjust content type based on image format
  );

  }


  return Response(body: "invalid");
}


Future<Response> post_image(RequestContext context) async {
  final request = context.request;
  final formData = await request.formData();

  final photo = formData.files['photo'];


  if (photo == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final imageBytes = await photo.readAsBytes() as List<int>;
  final hash = md5.convert(imageBytes);

  final file = File('./images/$hash.png');

  if (!(await file.exists())) {
    await file.writeAsBytes(imageBytes);
  }  

  return Response(body: '$hash.png');
}
