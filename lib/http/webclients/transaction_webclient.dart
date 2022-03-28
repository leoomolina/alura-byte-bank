import 'dart:convert';
import 'package:bytebank/models/transacao.dart';
import 'package:http/http.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transacao>> findAll() async {
    final Response response = await client.get(Uri.parse(baseUrl));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => Transacao.fromJson(json)).toList();
  }

  Future<Transacao?> save(Transacao transacao, String password) async {
    final String transactionJson = jsonEncode(transacao.toJson());

    //await Future.delayed(Duration(seconds: 2));

    final Response response = await client.post(Uri.parse(baseUrl),
        headers: {'Content-type': 'application/json', 'password': password},
        body: transactionJson);

    if (response.statusCode == 200) {
      return Transacao.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode), response.statusCode);
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponses[statusCode] != null) {
      return _statusCodeResponses[statusCode];
    }

    return 'Erro desconhecido';
  }

  static final Map<int, String> _statusCodeResponses = {
    400: "Ops! Ocorreu um erro durante a transação.",
    401: "Autenticação falhou",
    409: "Transação cadastrada já existe"
  };
}

class HttpException implements Exception {
  final String? message;
  final int? statusCode;

  HttpException(this.message, this.statusCode);
}
