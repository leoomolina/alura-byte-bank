import 'dart:convert';
import 'package:http/http.dart';
import '../webclient.dart';

const MESSAGES_URI =
    'https://gist.githubusercontent.com/leoomolina/d27c764dd569928f437a1f0a82d4fc43/raw/58969112ec6018abf45acfcc051eff51ae5fe5f8/';

class i18NWebClient {
  final String _viewKey;

  i18NWebClient(this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    final Response response =
        await client.get(Uri.parse('$MESSAGES_URI$_viewKey.json'));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
