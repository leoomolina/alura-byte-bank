import 'dart:convert';

import 'package:bytebank/models/contato.dart';
import 'package:bytebank/models/transacao.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request');
    print('url: ${data.url}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    print('status code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }
}

Future<List<Transacao>> findAll() async {
  Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );
  final Response response =
      await client.get(Uri.parse('http://192.168.5.66:8080/transactions'));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transacao> transacoes = [];
  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    transacoes.add(Transacao(transactionJson['value'],
        Contato(0, contactJson['name'], contactJson['account_number'])));
  }

  return transacoes;
}
