import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:notes_v1/helper_funcs/helper.dart';
import 'package:pointycastle/export.dart';

Future<RSAPublicKey> fetchPublicKey() async {
  final response = await http.get(Uri.parse('http://localhost:8080/test?username=John'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final modulus = BigInt.parse(data['modulus'] as String);
    final exponent = BigInt.parse(data['exponent'] as String);
    return RSAPublicKey(modulus, exponent);
  }
  throw Exception('Failed to fetch public key');
}

Future<String> postData(data) async{
  final url = Uri.parse('http://localhost:8080/test'); // Replace with your URL
  final headers = {
    'Content-Type': 'application/json',
  };

  // Example JSON data to send
  final body = jsonEncode({
    'data': data,
    'username': 'John'
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // Handle the successful response
      final responseData = jsonDecode(response.body);
      print('Response Data: $responseData');
    } else {
      // Handle error responses
      print('Error: ${response.statusCode}, ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Request failed: $e');
  }

  return 'Yes';
}

void main() async{
  final temp = await fetchPublicKey();
  const message = 'Hello from Dart Frog! Hello from Dart Frog! Hello from Dart Frog!';
  final encryptedData = rsaEncrypt(message, temp, null);
  // print(rsaDecrypt(encryptedData,encryptedData));

  
  print(encryptedData);

  final res = await postData(encryptedData);
  
  // print(res);
}