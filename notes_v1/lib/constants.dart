
const url = "http://localhost:8080";

const imagePathConstant = "/home/groupe/images";

String getNoteConstant(username, password){
  return '$url/notes?username=$username&password=$password';
}

String getMediaConstant(username, password, imageName){
  return "$url/media?username=$username&password=$password&photo=$imageName";
}

String getAuthConstant(username, password){
  return "$url/user_auth?username=$username&password=$password";
}

const registerUrl = "$url/user_auth";
const notesUrl = "$url/notes";