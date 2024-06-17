import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'departamento_form.dart'; // Importe a tela de formulário para adicionar ou editar departamentos

class DepartamentoList extends StatefulWidget {
  const DepartamentoList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DepartamentoListState createState() => _DepartamentoListState();
}

class _DepartamentoListState extends State<DepartamentoList> {
  List<dynamic> departamentos = [];

  @override
  void initState() {
    super.initState();
    fetchDepartamentos();
  }

  Future<void> fetchDepartamentos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/departamentos'));
    if (response.statusCode == 200) {
      setState(() {
        departamentos = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load departamentos');
    }
  }

  Future<void> deleteDepartamento(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/api/departamentos/$id'));
    if (response.statusCode == 200) {
      setState(() {
        departamentos.removeWhere((departamento) => departamento['id'] == id);
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Departamento deletado com sucesso!')));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao deletar departamento')));
    }
  }

  void navigateToForm({Map<String, dynamic>? departamento}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartamentoForm(departamento: departamento),
      ),
    );
    if (result == true) {
      fetchDepartamentos(); // Atualiza a lista de departamentos após adicionar ou editar um departamento
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => navigateToForm(),
          ),
        ],
      ),
      body: departamentos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: departamentos.length,
              itemBuilder: (context, index) {
                final departamento = departamentos[index];
                return ListTile(
                  title: Text(departamento['nome']),
                  subtitle: Text('Sigla: ${departamento['sigla']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => navigateToForm(departamento: departamento),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteDepartamento(departamento['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
