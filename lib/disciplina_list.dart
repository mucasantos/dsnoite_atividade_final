import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'disciplina_form.dart';

class DisciplinaList extends StatefulWidget {
  const DisciplinaList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DisciplinaListState createState() => _DisciplinaListState();
}

class _DisciplinaListState extends State<DisciplinaList> {
  List<Map<String, dynamic>> _disciplinas = [];

  @override
  void initState() {
    super.initState();
    _fetchDisciplinas();
  }

  Future<void> _fetchDisciplinas() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/disciplinas'));

    if (response.statusCode == 200) {
      setState(() {
        _disciplinas = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao carregar disciplinas')),
      );
    }
  }

  Future<void> _deleteDisciplina(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/api/disciplinas/$id'));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disciplina deletada com sucesso!')),
      );
      _fetchDisciplinas();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar disciplina')),
      );
    }
  }

  void _navigateToForm([Map<String, dynamic>? disciplina]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisciplinaForm(disciplina: disciplina)),
    );

    if (result == true) {
      _fetchDisciplinas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Disciplinas'),
      ),
      body: _disciplinas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _disciplinas.length,
              itemBuilder: (context, index) {
                final disciplina = _disciplinas[index];
                return ListTile(
                  title: Text(disciplina['nome']),
                  subtitle: Text('Carga Horária: ${disciplina['cargaHoraria']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _navigateToForm(disciplina),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteDisciplina(disciplina['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
