import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:notes_v1/helper_funcs/helper.dart';
import 'package:pointycastle/asymmetric/api.dart';



class userkeys{
  userkeys(RSAPublicKey p,RSAPrivateKey q){
    // print("hek");
    publicKey = p;
    privateKey = q;
  }

  RSAPublicKey? publicKey;
  RSAPrivateKey? privateKey;
}

Map<String, userkeys> users_keys = {};


Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => getkey(context),
    HttpMethod.post => post(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> getkey(RequestContext context) async {
  final keyPair = generateRSAKeyPair();
  final publicKey = keyPair.publicKey; // helpful in post request
  final privateKey = keyPair.privateKey;

  final request = context.request;
  final params = request.uri.queryParameters;

  final username = params['username'] ?? '__hello';

  if(username == '__hello'){
    return Response(body: "invalid");
  }

  users_keys[username] = userkeys(publicKey, privateKey);

  // print((users_keys[username]?.privateKey,username));
  // final encryptedData = rsaEncrypt(message, publicKey);
  final publicKeyString = jsonEncode({
    'modulus': publicKey.modulus.toString(),
    'exponent': publicKey.exponent.toString(),
  });
  // Returning encrypted data in a base64 encoded format
  return Response(body: publicKeyString);
}


Future<Response> post(RequestContext context) async{
  final request = context.request;
  final body = await request.json() as Map<String, dynamic>;

  final username = body['username'] ?? '__hello';

  if(username == '__hello'){
    return Response(body: "invalid");
  }

  // print((users_keys[username], username));
  print(rsaDecrypt(body['data'] as String, null, users_keys[username]!.privateKey!));
  // print(await rsaDecrypt(base64Decode(body['data'] as String), users_keys[username].publicKey!));

  // print()
  return Response.json(body: 'Hey There');
}