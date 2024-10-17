import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' show Encrypter, Encrypted, RSA;
import 'package:pointycastle/export.dart';


String uri = 'mongodb://admin:password@localhost:27017/user_account?authSource=admin'; 
// 'mongodb://sumitpurbey101:2Edl5MIGmCTUr1rJ@cluster0.it4yugo.mongodb.net/user_account?retryWrites=true&w=majority&appName=Cluster0';
//'mongodb://sumitpurbey101:water000@cluster0.it4yugo.mongodb.net:27017,cluster0.it4yugo.mongodb.net:27017,cluster0.it4yugo.mongodb.net:27017/user_account?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority';
// 'mongodb+srv://sumitpurbey101:2Edl5MIGmCTUr1rJ@cluster0.it4yugo.mongodb.net/user_account?retryWrites=true&w=majority'; 
//mongodb+srv://sumitpurbey101:2Edl5MIGmCTUr1rJ@cluster0.it4yugo.mongodb.net/user_account?retryWrites=true&w=majority

SecureRandom _secureRandom() {
  final secureRandom = FortunaRandom();

  // Seed the random number generator
  final seedSource = Random.secure();
  final seeds = List<int>.generate(32, (_) => seedSource.nextInt(255));
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

  return secureRandom;
}


AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
  final keyGen = RSAKeyGenerator();
  final keyParams = RSAKeyGeneratorParameters(
      BigInt.parse('65537'), 2048, 64); // Exponent, bit size, and certainty
  keyGen.init(ParametersWithRandom(keyParams, _secureRandom()));
  
  // Generate the key pair and explicitly cast it to RSAPublicKey and RSAPrivateKey
  final pair = keyGen.generateKeyPair();
  final publicKey = pair.publicKey as RSAPublicKey;
  final privateKey = pair.privateKey as RSAPrivateKey;

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
}


String rsaEncrypt(String data, RSAPublicKey publicKey, RSAPrivateKey? privateKey) {
  final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));
  List<String> result = [];
  if(data.length > 24){
    final nums = data.length ~/ 24;
    for(int i=0 ; i< nums; i++){
      // print(nums);
      result.add(encrypter.encrypt(data.substring(i*24,(i+1)*24)).base64);
    }  
    if(data.length > nums*24){
      result.add(encrypter.encrypt(data.substring(nums*24, data.length)).base64);
    }
  }else{
    return encrypter.encrypt(data).base64;
  }
  return result.join('--');
}

String rsaDecrypt(String encryptedData, RSAPublicKey? publicKey, RSAPrivateKey privateKey) {
  final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));

  return encrypter.decrypt(Encrypted(base64.decode(encryptedData)));
}

Uint8List _processInBlocks(RSAEngine engine, Uint8List input) {
  print((engine.inputBlockSize, input.lengthInBytes));
  final numBlocks = input.lengthInBytes ~/ engine.inputBlockSize;
  final result = BytesBuilder();
  Uint8List temp = Uint8List(numBlocks);
  engine.processBlock(input, 0, input.lengthInBytes,temp,0);
  print(temp);
    result.add(temp);
  for (var i = 0; i < numBlocks; i++) {
    engine.processBlock(input, i * engine.inputBlockSize, engine.inputBlockSize,temp,i * engine.inputBlockSize);
    print(temp);
    result.add(temp);
  }
  
  return result.toBytes();
}