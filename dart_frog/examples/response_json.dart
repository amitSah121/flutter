import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest (RequestContext context) async{
  // Access the incoming request.
  final request = context.request;

  final method = request.method.value; // get, put, ...
  final headers = request.headers; // Map<String, String>

  final params = request.uri.queryParameters;

  /*

  1) application/json
  curl --request POST \
    --url http://localhost:8080/example \
    --header 'Content-Type: application/json' \
    --data '{
    "hello": "world"
  }'

  {
    "request_body": {
      "hello": "world"
    }
  }
  */
  final body = await request.body();


  // Return a response.
  return Response.json(body: {"res":body});
}

