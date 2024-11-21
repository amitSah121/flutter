
import 'dart:io' show Platform, Directory;

import 'package:path_provider/path_provider.dart';

const url = "https://lemonwears.com/api";//"http://localhost:8080";


String? imagePathConstant  = "";

void initializeImagePath() {
  Future.microtask(() async {
    // print("helo");
    // String os = Platform.operatingSystem;
    String? home = "";
    Map<String, String> envVars = Platform.environment;
    
    if (Platform.isMacOS) {
      home = envVars['HOME'];
    } else if (Platform.isLinux) {
      home = envVars['HOME'];
    } else if (Platform.isWindows) {
      home = envVars['UserProfile'];
    } else if (Platform.isAndroid) {
      home = (await getApplicationDocumentsDirectory()).path;
    }

    // Ensure the directory exists
    Directory imageDir = Directory('$home/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // Assign the directory path to imagePathConstant
    imagePathConstant = imageDir.path;
    print(imagePathConstant);
    print("Images directory created at: $imagePathConstant");

    // You can return the path if needed
    return imagePathConstant;
  });
}


String getNoteConstant(username, password, modulus, exponent){
  return '$url/notes?username=$username&password=$password&modulus=$modulus&exponent=$exponent';
}

String getMediaConstant(username, password, imageName){
  return "$url/media?username=$username&password=$password&photo=$imageName";
}

String getAuthConstant(username, password){
  return "$url/user_auth?username=$username&password=$password";
}

const registerUrl = "$url/user_auth";
const notesUrl = "$url/notes";

const mediaUrl = "$url/media";

String getKey(username){
  
  return '$url/test?username=$username';
}
