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

Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);

const String baseUrl = 'http://192.168.5.66:8080/transactions';

Future<List<Transacao>> findAll() async {
  final Response response =
      await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transacao> transacoes = [];
  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    transacoes.add(Transacao(transactionJson['value'],
        Contato(0, contactJson['name'], contactJson['accountNumber'])));
  }

  return transacoes;
}

Future<Transacao> save(Transacao transacao) async {
  final Map<String, dynamic> transacaoMap = {
    'value': transacao.valor,
    'contact': {
      'name': transacao.contato.nome,
      'accountNumber': transacao.contato.numeroConta
    }
  };

  final String transactionJson = jsonEncode(transacaoMap);

  final Response response = await client.post(Uri.parse(baseUrl),
      headers: {'Content-type': 'application/json', 'password': '1000'},
      body: transactionJson);

  Map<String, dynamic> json = jsonDecode(response.body);

  final Map<String, dynamic> contactJson = json['contact'];
  return Transacao(
    json['value'],
    Contato(0, contactJson['name'], contactJson['accountNumber']),
  );
}
