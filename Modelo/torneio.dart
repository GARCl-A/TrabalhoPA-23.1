/*
 * Implementação da interface torneio-controlador
 * Contém lógica de alto nível do aplicativo, delegando detalhes específicos do torneio para o serviço "Regras"
*/

import '../bd/bd_teste.dart' show BDTeste;
import '../bd/torneio_bd_api.dart' show BD_API;
import 'torneio_api.dart' show Torneio_API;
import 'torneio_api_dados.dart' show Etapa, Placar, enum_estado_torneio, err_comp_add, err_comp_rem, err_concluir_etapa, err_criar_etapa, err_pedir_entrada, err_regras;

//import 'torneio_regras_api.dart';

class Torneio implements Torneio_API
{
  //Regras? _regras;
  BD_API _conexao_banco = BDTeste();


  // Cria torneio em preparo, retorna identificador do torneio
  @override
  ({bool sucesso, String id_torneio, String id_admin}) criar_torneio ()
  {
    var resposta = _conexao_banco.criar_torneio();
    if (resposta.id_torneio == '') return(sucesso: false, id_torneio: '', id_admin: '');

    return (sucesso: true, id_torneio: resposta.id_torneio, id_admin: resposta.id_admin);
  }

  @override
  ({String codigo_entrada, bool sucesso}) get_codigo_entrada (String id_torneio) {
    
    String codigo = _conexao_banco.get_codigo_entrada(id_torneio);
    
    if (codigo == '') return (sucesso: false, codigo_entrada: '');
    
    return (sucesso: true, codigo_entrada: codigo);
  }

  @override
  ({bool aceitar_pedidos, bool permitir_pedidos, bool sucesso}) get_torneio_config(String id_torneio) {
    var resposta = _conexao_banco.get_torneio_config(id_torneio);

    if (resposta.sucesso == false) return(sucesso: false, aceitar_pedidos: false, permitir_pedidos: false);

    return (sucesso: true,aceitar_pedidos: resposta.aceitar_pedidos, permitir_pedidos: resposta.permitir_pedidos);

  }

  @override
  ({err_pedir_entrada err, bool sucesso}) aceitar_entrada(String id_torneio, String nome_competidor, [String? id_admin]) {
    // TODO: implement aceitar_entrada
    throw UnimplementedError();
  }

  @override
  ({bool sucesso}) set_torneio_config({String? id_torneio, bool? permitir_pedidos, bool? aceitar_pedidos}) {
    // TODO: implement set_torneio_config
    throw UnimplementedError();
  }

  @override
  ({err_comp_add err, bool sucesso}) adicionar_competidor(String id_torneio, String nome_competidor) {
    // TODO: implement adicionar_competidor
    throw UnimplementedError();
  }

  @override
  ({bool is_admin, bool sucesso}) check_if_admin(String id_torneio, String id_admin) {
    // TODO: implement check_if_admin
    throw UnimplementedError();
  }

  @override
  ({err_concluir_etapa err, String msg, bool sucesso}) concluir_etapa(String id_torneio, Etapa etapa_atual) {
    // TODO: implement concluir_etapa
    throw UnimplementedError();
  }

  @override
  ({err_criar_etapa err, Etapa proxima_etapa, bool sucesso}) criar_proxima_etapa(String id_torneio) {
    // TODO: implement criar_proxima_etapa
    throw UnimplementedError();
  }

  @override
  ({err_regras err, bool sucesso}) definir_regras(String id_torneio, String regras) {
    // TODO: implement definir_regras
    throw UnimplementedError();
  }

  @override
  ({List competidores, bool sucesso}) get_competidores(String id_torneio) {
    // TODO: implement get_competidores
    throw UnimplementedError();
  }
  
  @override
  ({enum_estado_torneio estado, bool sucesso}) get_estado_torneio(String id_torneio) {
    // TODO: implement get_estado_torneio
    throw UnimplementedError();
  }
  
  @override
  ({Etapa etapa_atual, bool sucesso}) get_etapa_atual(String id_torneio) {
    // TODO: implement get_etapa_atual
    throw UnimplementedError();
  }
  
  @override
  ({List<Etapa> Etapas, bool sucesso}) get_etapas_torneio(String id_torneio) {
    // TODO: implement get_etapas_torneio
    throw UnimplementedError();
  }
  
  @override
  ({List pedidos, bool sucesso}) get_pedidos_entrada(String id_torneio) {
    // TODO: implement get_pedidos_entrada
    throw UnimplementedError();
  }
  
  @override
  ({Placar placar, bool sucesso}) get_placar(String id_torneio) {
    // TODO: implement get_placar
    throw UnimplementedError();
  }
  
  @override
  ({err_pedir_entrada err, bool sucesso}) pedir_entrada(String id_torneio, String nome_competidor, String codigo_entrada) {
    // TODO: implement pedir_entrada
    throw UnimplementedError();
  }
  
  @override
  ({err_comp_rem err, bool sucesso}) remover_competidor(String id_torneio, String nome_competidor) {
    // TODO: implement remover_competidor
    throw UnimplementedError();
  }
  
  @override
  ({bool sucesso}) voltar_etapa(String id_torneio) {
    // TODO: implement voltar_etapa
    throw UnimplementedError();
  }



}
