class Transferencia {
  final double valor;
  final String numeroConta;

  Transferencia(
    this.valor,
    this.numeroConta,
  );

  @override
  String toString() {
    return 'Numero Conta: ' + numeroConta + ' / ' + valor.toString();
  }
}
