/*
 * Implementação da interface torneio-banco de dados para fins de teste
 * 
*/

import 'torneio_bd_api.dart';


class BDTeste extends BD_API
{
  String id_torneio_teste = "ID_TORNEIO_DUMMY";
  String id_admin_teste = "ID_ADMIN_DUMMY";
  String codigo_entrada_teste = "CODIGO_ENTRADA_DUMMY";

  bool aceitar_pedidos_teste = false;
  bool permitir_pedidos_teste = false;

  @override
  ({String id_admin, String id_torneio}) criar_torneio() {
    return (id_admin: id_admin_teste, id_torneio: id_torneio_teste);
  }

  @override
  String get_codigo_entrada(String id_torneio) {
    if (id_torneio == id_torneio_teste)
    {
      return codigo_entrada_teste;
    }
    return '';
  }

  @override
  ({bool sucesso, bool aceitar_pedidos, bool permitir_pedidos}) get_torneio_config(String id_torneio) {
    if (id_torneio == id_torneio_teste)
      return (sucesso : true, aceitar_pedidos: aceitar_pedidos_teste, permitir_pedidos: permitir_pedidos_teste);
    
    return (sucesso: false, aceitar_pedidos: false, permitir_pedidos: false);
    
  }

}