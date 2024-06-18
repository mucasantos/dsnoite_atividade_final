import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MatriculaList extends StatefulWidget {
  const MatriculaList({super.key});

  @override
  _MatriculaListState createState() => _MatriculaListState();
}

class _MatriculaListState extends State<MatriculaList> {
  List<dynamic> _matriculas = [];

  @override
  void initState() {
    _fetchMatriculas();
    super.initState();
  }

  Future<void> _fetchMatriculas() async {
    final dio = Dio();
    const String myUrl = 'http://192.168.0.123:3000/api/matriculas';

    try {
      final response = await dio.get(myUrl);

      if (response.statusCode == 200) {
        setState(() {
          _matriculas = response.data as List<dynamic>;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao buscar matrículas')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteMatricula(int id) async {
    final url = Uri.parse('http://localhost:3000/api/matriculas/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Matrícula deletada com sucesso!')),
      );
      _fetchMatriculas();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar matrícula')),
      );
    }
  }

  void _editMatricula(Map<String, dynamic> matricula) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatriculaForm(matricula: matricula),
      ),
    ).then((_) {
      _fetchMatriculas();
    });
  }

  void _addMatricula() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MatriculaForm(),
      ),
    ).then((_) {
      _fetchMatriculas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Matrículas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMatricula,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _matriculas.length,
        itemBuilder: (context, index) {
          final matricula = _matriculas[index];
          return ListTile(
            title: Text('Disciplina ID: ${matricula['disciplinaId']}'),
            subtitle: Text('Nota Final: ${matricula['notaFinal']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editMatricula(matricula),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteMatricula(matricula['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MatriculaForm extends StatefulWidget {
  final Map<String, dynamic>? matricula;

  const MatriculaForm({super.key, this.matricula});

  @override
  _MatriculaFormState createState() => _MatriculaFormState();
}

class _MatriculaFormState extends State<MatriculaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notaFinalController = TextEditingController();
  final TextEditingController _numeroPresencasController = TextEditingController();
  final TextEditingController _numeroFaltasController = TextEditingController();
  int? _selectedDisciplinaId;
  int? _selectedMatriculaId;

  @override
  void initState() {
    super.initState();
    if (widget.matricula != null) {
      _selectedMatriculaId = widget.matricula!['id'];
      _notaFinalController.text = widget.matricula!['notaFinal'].toString();
      _numeroPresencasController.text = widget.matricula!['numeroPresencas'].toString();
      _numeroFaltasController.text = widget.matricula!['numeroFaltas'].toString();
      _selectedDisciplinaId = widget.matricula!['disciplinaId'];
    }
  }

  @override
  void dispose() {
    _notaFinalController.dispose();
    _numeroPresencasController.dispose();
    _numeroFaltasController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> matricula = {
        'notaFinal': double.tryParse(_notaFinalController.text),
        'numeroPresencas': int.tryParse(_numeroPresencasController.text),
        'numeroFaltas': int.tryParse(_numeroFaltasController.text),
        'disciplinaId': _selectedDisciplinaId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = _selectedMatriculaId == null
          ? Uri.parse('http://localhost:3000/api/matriculas')
          : Uri.parse('http://localhost:3000/api/matriculas/$_selectedMatriculaId');

      final response = _selectedMatriculaId == null
          ? await http.post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(matricula))
          : await http.put(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(matricula));

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_selectedMatriculaId == null
                  ? 'Matrícula inserida com sucesso!'
                  : 'Matrícula atualizada com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar matrícula')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Matrículas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _notaFinalController,
                decoration: const InputDecoration(labelText: 'Nota Final'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a nota final';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numeroPresencasController,
                decoration: const InputDecoration(labelText: 'Número de Presenças'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o número de presenças';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numeroFaltasController,
                decoration: const InputDecoration(labelText: 'Número de Faltas'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o número de faltas';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Disciplina ID'),
                initialValue: _selectedDisciplinaId?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _selectedDisciplinaId = int.tryParse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o Disciplina ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_selectedMatriculaId == null
                    ? 'Adicionar Matrícula'
                    : 'Atualizar Matrícula'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
