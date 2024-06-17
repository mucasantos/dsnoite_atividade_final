import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DisciplinaForm extends StatefulWidget {
  final Map<String, dynamic>? disciplina;

  const DisciplinaForm({super.key, this.disciplina});

  @override
  // ignore: library_private_types_in_public_api
  _DisciplinaFormState createState() => _DisciplinaFormState();
}

class _DisciplinaFormState extends State<DisciplinaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cargaHorariaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.disciplina != null) {
      _nomeController.text = widget.disciplina!['nome'];
      _cargaHorariaController.text = widget.disciplina!['cargaHoraria'].toString();
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> disciplina = {
        'nome': _nomeController.text,
        'cargaHoraria': int.parse(_cargaHorariaController.text),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = widget.disciplina == null
          ? Uri.parse('http://localhost:3000/api/disciplinas')
          : Uri.parse('http://localhost:3000/api/disciplinas/${widget.disciplina!['id']}');

      final response = widget.disciplina == null
          ? await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(disciplina))
          : await http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(disciplina));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.disciplina == null ? 'Disciplina inserida com sucesso!' : 'Disciplina atualizada com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar disciplina')),
        );
      }
    }
  }

  Future<void> _deleteDisciplina(int id) async {
    final url = Uri.parse('http://localhost:3000/api/disciplinas/$id');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disciplina deletada com sucesso!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar disciplina')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cargaHorariaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.disciplina == null ? 'Adicionar Disciplina' : 'Editar Disciplina'),
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
                controller: _cargaHorariaController,
                decoration: const InputDecoration(labelText: 'Carga Horária'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a carga horária';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.disciplina == null ? 'Inserir' : 'Atualizar'),
              ),
              if (widget.disciplina != null)
                ElevatedButton(
                  onPressed: () => _deleteDisciplina(widget.disciplina!['id']),
                  child: const Text('Deletar'),
                  //style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
