import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  final db = await Db.create(
      'mongodb://localhost:27017/my_database'); //Completamente placeholder isso aqui.

  await db.open();

  final torneiosCollection = db.collection('torneios');
}
