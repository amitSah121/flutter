import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest (RequestContext context) async{
  // Access the incoming request.
  final request = context.request;

  final method = request.method.value; // get, put, ...
  final headers = request.headers; // Map<String, String>

  final params = request.uri.queryParameters;

  /*

  1) text/plain
  curl --request POST \
    --url http://localhost:8080 \
    --header 'Content-Type: text/plain' \
    --data 'Hello!'

  The body is "Hello!".

  */
  final body = await request.body();


  // Return a response.
  return Response(body: params["a"]);
}

