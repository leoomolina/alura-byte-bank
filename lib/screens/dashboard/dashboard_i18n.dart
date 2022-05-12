import '../../components/localization/i18n_messages.dart';

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String? get transferencia => _messages.get("transferencia");

  String? get transaction_feed => _messages.get("transaction_feed");

  String? get alterar_nome => _messages.get("alterar_nome");
}
