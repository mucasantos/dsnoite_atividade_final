import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfessorList extends StatefulWidget {
  const ProfessorList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfessorListState createState() => _ProfessorListState();
}

class _ProfessorListState extends State<ProfessorList> {
  List<dynamic> _professores = [];

  @override
  void initState() {
    _fetchProfessores();

    super.initState();
  }

  Future<void> _fetchProfessores() async {
    print("Fetch Professores");
    final dio = Dio();
    const String myUrl = 'http://192.168.0.123:3000/api/professores';

    try {
      final response = await dio.get(myUrl);

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("auiiiii");
        setState(() {
          _professores = response.data as List<dynamic>;
        });
      } else {
        // ignore: use_build_context_synchronously
        print("no else...");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao buscar professores')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteProfessor(int id) async {
    final url = Uri.parse('http://localhost:3000/api/professores/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Professor deletado com sucesso!')),
      );
      _fetchProfessores();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar professor')),
      );
    }
  }

  void _editProfessor(Map<String, dynamic> professor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfessorForm(professor: professor),
      ),
    ).then((_) {
      _fetchProfessores();
    });
  }

  void _addProfessor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfessorForm(),
      ),
    ).then((_) {
      _fetchProfessores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Professores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProfessor,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _professores.length,
        itemBuilder: (context, index) {
          final professor = _professores[index];
          return ListTile(
            title: Text(professor['nome']),
            subtitle: Text('CPF: ${professor['cpf']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editProfessor(professor),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteProfessor(professor['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
  int? _selectedProfessorId;

  @override
  void initState() {
    super.initState();
    if (widget.professor != null) {
      _selectedProfessorId = widget.professor!['id'];
      _nomeController.text = widget.professor!['nome'];
      _cpfController.text = widget.professor!['cpf'];
      _enderecoController.text = widget.professor!['endereco'];
      _selectedDepartamentoId = widget.professor!['departamentoId'];
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    super.dispose();
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

      final url = _selectedProfessorId == null
          ? Uri.parse('http://localhost:3000/api/professores')
          : Uri.parse('http://localhost:3000/api/professores/$_selectedProfessorId');

      final response = _selectedProfessorId == null
          ? await http.post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(professor))
          : await http.put(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(professor));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_selectedProfessorId == null
                  ? 'Professor inserido com sucesso!'
                  : 'Professor atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar professor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Professores'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Departamento ID'),
                initialValue: _selectedDepartamentoId?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartamentoId = int.tryParse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o Departamento ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_selectedProfessorId == null
                    ? 'Adicionar Professor'
                    : 'Atualizar Professor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
