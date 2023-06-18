/*
 * Implementação da interface torneio-banco de dados usando mongo_db
 * 
*/

import 'torneioBdApi2.dart';

import 'package:mongo_dart/mongo_dart.dart';

void main() async
{
  /*
  await MongoConnection.create();
  var minhaConexao = MongoConnection();
  //print(await minhaConexao.remover_competidor('S4duGbWuNg', 'Compet A'));
  
  minhaConexao.meth_test();
  */
  
  

}


class MongoConnection implements TorneioBdApi
{
  
  
  static Db ? _db;
  static DbCollection ? _torneiosCollection;
  
  static Future<void> create() async
  {
    print("Conectando ao mongodb...");
    _db = await Db.create(
      'mongodb://localhost:27017/my_database'); //Completamente placeholder isso aqui.

    print(_db);

    print("attempting to open...");
    await _db!.open();

    print("collection maybe?");
    _torneiosCollection = _db!.collection('torneios');
    print("Conectado!");
  }

  static Future<void> close() async
  {
    await _db?.close();
  }
  
  @override
  Future<({bool sucesso})> criarTorneio(Map<String,dynamic> torneioInicial) async {
    
    var escrita = await _torneiosCollection?.insertOne(torneioInicial);
    if (escrita?.isSuccess == true)
    {
      return (sucesso:true);
    }

    return (sucesso:false);

  }
  
  @override
  Future<({bool sucesso})> deleteTorneio(String idTorneio) async {
    var resultado = await getTorneio(idTorneio);

    if (resultado.sucesso == false)
    {
      return (sucesso:false);
    }

    var res_removido = await _torneiosCollection?.deleteOne({'id_torneio': idTorneio});
    if (res_removido?.isSuccess == true)
    {
      return (sucesso:true);
    }

    return (sucesso:false);

  }
  
  @override
  Future<({bool sucesso, Map<String,dynamic> ? torneio})> getTorneio(String idTorneio) async {
    var resultado = await _torneiosCollection?.findOne(where.eq("id_torneio", idTorneio));

    if (resultado == null)
    {
      return (sucesso: false, torneio:  resultado);
    }

    return (sucesso:true, torneio:resultado);
  }
  
  @override
  Future<({bool sucesso})> replaceTorneio(String idTorneio, Map<String,dynamic> torneioAlterado) async {
    
    var resultado = await getTorneio(idTorneio);

    if (resultado.sucesso == false)
    {
      return (sucesso:false);
    }
    
    if (torneioAlterado['id_torneio'] == null) return (sucesso:false);

    var res_replace = await _torneiosCollection?.replaceOne({'id_torneio':idTorneio}, torneioAlterado);

    if (res_replace?.isSuccess == false) return (sucesso:false);

    return (sucesso:true);
  }
  


}