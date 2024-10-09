import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async{
  return Response(body: 'Welcome to Dart Frog!');
}

// mongodb://admin@localhost:27017/dbname?authSource=admin
// export PATH="$PATH":"$HOME/.pub-cache/bin"