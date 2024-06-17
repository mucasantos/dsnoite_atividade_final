import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'curso_form.dart';

class CursoList extends StatefulWidget {
  const CursoList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CursoListState createState() => _CursoListState();
}

class _CursoListState extends State<CursoList> {
  List<dynamic> cursos = [];

  @override
  void initState() {
    super.initState();
    fetchCursos();
  }

  Future<void> fetchCursos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/cursos'));
    if (response.statusCode == 200) {
      setState(() {
        cursos = json.decode(response.body);
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao carregar cursos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CursoForm()),
              );
              if (result == true) {
                fetchCursos();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cursos.length,
        itemBuilder: (context, index) {
          final curso = cursos[index];
          return ListTile(
            title: Text(curso['nome']),
            subtitle: Text(curso['descricao']),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CursoForm(curso: curso),
                ),
              );
              if (result == true) {
                fetchCursos();
              }
            },
          );
        },
      ),
    );
  }
}
