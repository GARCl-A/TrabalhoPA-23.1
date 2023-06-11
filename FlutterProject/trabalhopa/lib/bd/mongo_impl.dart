/*
 * Implementação da interface torneio-banco de dados usando mongo_db
 * 
*/

import '../constants/modos_torneio.dart';
import 'torneio_bd_api.dart';
import 'torneio_bd_api_dados.dart';
import '../constants/torneio_states.dart';

import 'package:mongo_dart/mongo_dart.dart';

// Geração de strings aleatórias para servir como código de torneio
// Deve ser passado posteriormente para torneio.dart
import 'dart:math';
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
const _chars_n = 10;
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

void main() async
{
  await MongoConnection.create();
  var minhaConexao = MongoConnection();
  print(await minhaConexao.remover_competidor('S4duGbWuNg', 'Compet A'));
  
  //minhaConexao.meth_test();
  

}


class MongoConnection implements BD_API
{
  
  Future<void> meth_test() async
  {
    var resposta = await _torneiosCollection?.findOne(where.eq('id_torneio', '6eCXffwU4Z'));
    print(resposta?['id_admin']);
    print(resposta?['inexistente']);
  }
  
  static Db ? _db;
  static DbCollection ? _torneiosCollection;
  
  static Future<void> create() async
  {
    print("Conectando ao mongodb...");
    _db = await Db.create(
      'mongodb://localhost:27017/my_database'); //Completamente placeholder isso aqui.

    await _db!.open();

    _torneiosCollection = _db!.collection('torneios');
    print("Conectado!");
  }

  @override
  Future<({String ? id_admin, String ? id_torneio})> criar_torneio() async 
  {  
    // Gera strings aleatórias para id_admin e id_torneio
    // Confere se não há outro torneio com mesmo id
    // Insere torneio no banco com outros dados de valor padrão

    String ? codigoTorneio;
    var resultado;
    for (int i = 0; i < 100; i++)
    {
      codigoTorneio = getRandomString(_chars_n);
      resultado = await _torneiosCollection?.findOne(where.eq("id_torneio", codigoTorneio));
      if (resultado == null) break;
    }

    if (resultado != null)
    {
      return (id_admin: null, id_torneio: null);
    }
     
    String ? codigoAdmin = getRandomString(_chars_n);
    String ? codigoEntrada = getRandomString(_chars_n);

    var escrita = await _torneiosCollection?.insertOne(
    {
      'id_torneio'          :     codigoTorneio,
      'id_admin'            :     codigoAdmin,
      'codigo_entrada'      :     codigoEntrada,

      'estado'              :     enum_estado_torneio.em_preparo.index,

      'permitir_pedidos'    :     true,
      'aceitar_pedidos'     :     false,

      'competidores'        :     [],
      'pedidos_comp'        :     [],
      
      'regras'              :     enum_modos_torneio.nao_selecionado
    }
    );

    if (escrita?.isSuccess == false)
    {
      return (id_admin: null, id_torneio: null);
    }

    return (id_admin: codigoAdmin, id_torneio: codigoTorneio);
  }

  @override
  Future<({bool sucesso, TorneioModelo? torneio})> get_dados_torneio(String id_torneio) async 
  {
    
    var resultado = await _torneiosCollection?.findOne(where.eq("id_torneio", id_torneio));

    if (resultado == null)
    {
      return (sucesso: false, torneio:  null);
    }

    var torn_sel = TorneioModelo();

    torn_sel.id_torneio         = resultado['id_torneio'];
    torn_sel.id_admin           = resultado['id_admin'];
    torn_sel.codigo_entrada     = resultado['codigo_entrada'];

    torn_sel.competidores       = resultado['competidores'];
    torn_sel.pedidos_comp       = resultado['pedidos_comp'];

    torn_sel.permitir_pedidos   = resultado['permitir_pedidos'];
    torn_sel.aceitar_pedidos    = resultado['aceitar_pedidos'];

    torn_sel.regras             = enum_modos_torneio.values[resultado['regras']??0];     //default : não selecionado
    torn_sel.estado_torneio     = enum_estado_torneio.values[resultado['estado_torneio']??0];   //default: em preparo

    return (torneio: torn_sel, sucesso: true);

  }

  @override
  ({bool sucesso}) aceitar_pedido_entrada(String id_torneio, String nome_competidor) {
    // TODO: implement adicionar_competidor
    throw UnimplementedError();
  }

  @override
  Future<({bool sucesso})> adicionar_competidor(String id_torneio, String nome_competidor) async 
  {
    
    var resultado = await _torneiosCollection?.findOne(where.eq("id_torneio", id_torneio));

    if (resultado == null)
    {
      return (sucesso: false);
    }

    List compList = resultado['competidores'];
    compList.add(nome_competidor);
    resultado['competidores'] = compList;

    var res_replace = await _torneiosCollection?.replaceOne({'id_torneio':id_torneio}, resultado);

    if (res_replace?.isSuccess == false) return (sucesso:false);

    return (sucesso:true);
  }

  @override
  ({bool sucesso}) adicionar_pedido_entrada(String id_torneio, String nome_competidor) {
    // TODO: implement adicionar_pedido_entrada
    throw UnimplementedError();
  }

  @override
  Future <({bool sucesso})> definir_regras(String id_torneio, enum_modos_torneio regras) async
  {
    var resultado = await _torneiosCollection?.findOne(where.eq("id_torneio", id_torneio));

    if (resultado == null)
    {
      return (sucesso: false);
    }

    resultado['regras'] = regras.index;
    var res_replace = await _torneiosCollection?.replaceOne({'id_torneio':id_torneio}, resultado);

    if (res_replace?.isSuccess == false) return (sucesso:false);

    return (sucesso:true);
    
  }

  @override
  Future<({bool sucesso})> remover_competidor(String id_torneio, String nome_competidor) async
  {
    // Conferir se torneio existe
    var resultado = await _torneiosCollection?.findOne(where.eq("id_torneio", id_torneio));
    if (resultado == null)
    {
      return (sucesso: false);
    }

    // Remover competidor, conferir se este existe
    List compList = resultado['competidores'];
    var removido = compList.remove(nome_competidor);
    if (removido == false) return (sucesso:false);

    // Atualizar bd
    resultado['competidores'] = compList;
    var res_replace = await _torneiosCollection?.replaceOne({'id_torneio':id_torneio}, resultado);
    if (res_replace?.isSuccess == false) return (sucesso:false);

    return (sucesso:true);
  }

  @override
  ({bool sucesso}) set_torneio_config(String id_torneio, {bool? permitir_pedidos, bool? aceitar_pedidos}) {
    // TODO: implement set_torneio_config
    throw UnimplementedError();
  }

}