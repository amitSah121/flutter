
import 'dart:io' show Platform, Directory;

const url = "https://lemonwears.com/api";//"http://localhost:8080";


String? imagePathConstant  = ((){
  String os = Platform.operatingSystem;
  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }


  Directory('$home/images').create(recursive: true); 

  return '$home/images';
})();

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