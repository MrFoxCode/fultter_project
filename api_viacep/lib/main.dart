import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Consulta de CEP'),
        ),
        body: CepSearchForm(),
      ),
    );
  }
}

class CepSearchForm extends StatefulWidget {
  @override
  _CepSearchFormState createState() => _CepSearchFormState();
}

class _CepSearchFormState extends State<CepSearchForm> {
  final TextEditingController _cepController = TextEditingController();
  String _result = '';

  Future<void> _searchCep() async {
    final cep = _cepController.text;
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _result = 'CEP: ${data['cep']}\n'
            'Logradouro: ${data['logradouro']}\n'
            'Bairro: ${data['bairro']}\n'
            'Cidade: ${data['localidade']}\n'
            'Estado: ${data['uf']}';
      });
    } else {
      setState(() {
        _result = 'CEP não encontrado';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _cepController,
            decoration: InputDecoration(labelText: 'CEP'),
          ),
          ElevatedButton(
            onPressed: _searchCep,
            child: Text('Consultar CEP'),
          ),
          SizedBox(height: 16.0),
          Text(_result),
        ],
      ),
    );
  }
}