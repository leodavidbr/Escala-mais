import 'dart:convert';

import 'package:escala_mais/core/logging/app_logger.dart';
import 'package:http/http.dart' as http;

class CepAddress {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  CepAddress({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory CepAddress.fromJson(Map<String, dynamic> json) {
    return CepAddress(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  @override
  String toString() {
    return '$logradouro, $bairro, $localidade - $uf';
  }
}

class CepService {
  Future<CepAddress?> fetchAddress(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCep.length != 8) return null;

    final url = Uri.parse('https://viacep.com.br/ws/$cleanCep/json/');

    try {
      logInfo('CEP lookup started', {'cep': cleanCep, 'url': url.toString()});
      final response = await http.get(url);

      if (response.statusCode == 200) {
        logDebug(
          'CEP lookup success',
          {'statusCode': response.statusCode, 'bodyLength': response.body.length},
        );
        final json = jsonDecode(response.body);
        if (json.containsKey('erro')) {
          logWarning('CEP not found', {'cep': cleanCep});
          return null;
        }
        return CepAddress.fromJson(json);
      }
      logWarning(
        'CEP lookup non-200 response',
        {'statusCode': response.statusCode, 'body': response.body},
      );
      return null;
    } catch (e, stackTrace) {
      logError('CEP lookup failed', e, stackTrace);
      return null;
    }
  }
}
