import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfessorForm extends StatefulWidget {
  final Map<String, dynamic>? professor;

  const ProfessorForm({super.key, this.professor});

  @override
  // ignore: library_private_types_in_public_api
  _ProfessorFormState createState() => _ProfessorFormState();
}

class _ProfessorFormState extends State<ProfessorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  int? _selectedDepartamentoId;

  @override
  void initState() {
    super.initState();
    if (widget.professor != null) {
      _nomeController.text = widget.professor!['nome'];
      _cpfController.text = widget.professor!['cpf'];
      _enderecoController.text = widget.professor!['endereco'];
      _selectedDepartamentoId = widget.professor!['departamentoId'];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> professor = {
        'nome': _nomeController.text,
        'cpf': _cpfController.text,
        'endereco': _enderecoController.text,
        'departamentoId': _selectedDepartamentoId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = widget.professor == null
          ? Uri.parse('http://localhost:3000/api/professores')
          : Uri.parse('http://localhost:3000/api/professores/${widget.professor!['id']}');

      final response = widget.professor == null
          ? await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(professor))
          : await http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(professor));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.professor == null ? 'Professor inserido com sucesso!' : 'Professor atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar professor')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.professor == null ? 'Adicionar Professor' : 'Editar Professor'),
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
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              // Adicione um campo para selecionar o departamento, se necessário
              // DropdownButtonFormField(
              //   value: _selectedDepartamentoId,
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedDepartamentoId = value as int?;
              //     });
              //   },
              //   items: [
              //     // Adicione itens de dropdown aqui
              //   ],
              //   decoration: InputDecoration(labelText: 'Departamento'),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.professor == null ? 'Inserir' : 'Atualizar'),
              ),
              if (widget.professor != null)
                ElevatedButton(
                  onPressed: () => _deleteProfessor(widget.professor!['id']),
                  child: const Text('Deletar'),
                 // style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProfessor(int professorId) async {
    final url = Uri.parse('http://localhost:3000/api/professores/$professorId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Professor deletado com sucesso!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar professor')),
      );
    }
  }
}
