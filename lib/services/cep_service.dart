import 'dart:convert';
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
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json.containsKey('erro')) {
          return null;
        }
        return CepAddress.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
