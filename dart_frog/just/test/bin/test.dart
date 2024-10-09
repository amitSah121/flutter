import 'package:test/test.dart' as test;
import 'package:mongo_dart/mongo_dart.dart';

void main(List<String> arguments) {
  onRequest();
  print('Hello world: ${test.calculate()}!');
}

Future<void> onRequest() async{
  final db = Db('mongodb://admin:password@localhost:27017/user_account?authSource=admin');
  await db.open();
  final coll = db.collection('user');
  // final p1 = await coll.find({'name':'Hooll'}).toList();
  // print(p1);
  final result = await coll.insertMany([
    {'login': 'jdoe', 'name': 'John Doe', 'email': 'john@doe.com'},
    {'login': 'lsmith', 'name': 'Lucy Smith', 'email': 'lucy@smith.com'}
  ]);
  print('Inserted Count: ${result.insertedCount}'); // Number of inserted documents
  
  // print(temp);
  await db.close();
}

