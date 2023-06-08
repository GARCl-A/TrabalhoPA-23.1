/*
 * Interface utilizada por torneio para buscar e armazernar dados
 * 
*/

abstract class BD_API
{
  // Cria um torneio, registrando seu id, id_admin e configuração padrão inicial
  ({String id_torneio, String id_admin})
  criar_torneio
  ();

  // Retorna o codigo de entrada da aplicação. Caso não exista, gera, registra e retorna.
  String get_codigo_entrada(String id_torneio);

  // Retorna
  ({bool sucesso,bool permitir_pedidos, bool aceitar_pedidos}) get_torneio_config(String id_torneio);
}