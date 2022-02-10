import 'dart:convert';
import 'package:bytebank/models/transacao.dart';
import 'package:http/http.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transacao>> findAll() async {
    final Response response =
        await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Transacao.fromJson(json)).toList();
  }

  Future<Transacao> save(Transacao transacao, String password) async {
    final String transactionJson = jsonEncode(transacao.toJson());
    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {'Content-type': 'application/json', 'password': password},
        body: transactionJson);

    if (response.statusCode == 400) {
      throw new Exception("Ops! Ocorreu um erro durante a transação.");
    }

    if (response.statusCode == 401) {
      throw new Exception("Autenticação falhou");
    }

    return Transacao.fromJson(jsonDecode(response.body));
  }
}
