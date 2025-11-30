import 'dart:convert';
import 'package:http/http.dart' as http;

class CepAddress {
  final String cep;
  final String street;
  final String neighborhood;
  final String locality;
  final String uf;

  CepAddress({
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.locality,
    required this.uf,
  });

  factory CepAddress.fromJson(Map<String, dynamic> json) {
    return CepAddress(
      cep: json['cep'] ?? '',
      street: json['street'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      locality: json['locality'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  @override
  String toString() {
    return '$street, $neighborhood, $locality - $uf';
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
