import 'package:bytebank/models/contato.dart';

class Transacao {
  final String id;
  final double valor;
  final Contato contato;

  Transacao(
    this.id,
    this.valor,
    this.contato,
  );

  Transacao.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        valor = json['value'],
        contato = Contato.fromJson(json['contact']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': valor,
        'contact': contato.toJson(),
      };

  @override
  String toString() {
    return 'Transacao{id: $id, valor: $valor, contato: $contato}';
  }
}
