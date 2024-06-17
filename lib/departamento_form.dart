import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DepartamentoForm extends StatefulWidget {
  final Map<String, dynamic>? departamento;

  const DepartamentoForm({super.key, this.departamento});

  @override
  // ignore: library_private_types_in_public_api
  _DepartamentoFormState createState() => _DepartamentoFormState();
}

class _DepartamentoFormState extends State<DepartamentoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _siglaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.departamento != null) {
      _nomeController.text = widget.departamento!['nome'];
      _siglaController.text = widget.departamento!['sigla'];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> departamento = {
        'nome': _nomeController.text,
        'sigla': _siglaController.text,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = widget.departamento == null
          ? Uri.parse('http://localhost:3000/api/departamentos')
          : Uri.parse('http://localhost:3000/api/departamentos/${widget.departamento!['id']}');

      final response = widget.departamento == null
          ? await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(departamento))
          : await http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(departamento));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.departamento == null ? 'Departamento inserido com sucesso!' : 'Departamento atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar departamento')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _siglaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.departamento == null ? 'Adicionar Departamento' : 'Editar Departamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _siglaController,
                decoration: const InputDecoration(labelText: 'Sigla'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a sigla';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.departamento == null ? 'Inserir' : 'Atualizar'),
              ),
              if (widget.departamento != null)
                ElevatedButton(
                  onPressed: () => _deleteDepartamento(widget.departamento!['id']),
                  child: const Text('Deletar'),
                 // style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteDepartamento(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/api/departamentos/$id'));
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Departamento deletado com sucesso!')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao deletar departamento')));
    }
  }
}
