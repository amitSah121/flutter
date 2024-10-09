import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  // Access the incoming request.
  final request = context.request;

  final method = request.method.value; // get, put, ...
  final headers = request.headers; // Map<String, String>

  final params = request.uri.queryParameters;

  // Do stuff with the incoming request...

  // Return a response.
  return Response(body: params["a"]);
}

