import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CursoForm extends StatefulWidget {
  final Map<String, dynamic>? curso;

  const CursoForm({super.key, this.curso});

  @override
  // ignore: library_private_types_in_public_api
  _CursoFormState createState() => _CursoFormState();
}

class _CursoFormState extends State<CursoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _cargaHorariaSemestreController = TextEditingController();
  final TextEditingController _cargaHorariaTotalController = TextEditingController();
  final TextEditingController _numeroSemestresController = TextEditingController();
  final TextEditingController _nivelController = TextEditingController();
  int? _selectedDepartamentoId;
  List<dynamic> departamentos = [];

  @override
  void initState() {
    super.initState();
    if (widget.curso != null) {
      _nomeController.text = widget.curso!['nome'];
      _descricaoController.text = widget.curso!['descricao'];
      _cargaHorariaSemestreController.text = widget.curso!['cargaHorariaSemestre'].toString();
      _cargaHorariaTotalController.text = widget.curso!['cargaHorariaTotal'].toString();
      _numeroSemestresController.text = widget.curso!['numeroSemestres'].toString();
      _nivelController.text = widget.curso!['nivel'];
      _selectedDepartamentoId = widget.curso!['departamentoid'];
    }
    fetchDepartamentos();
  }

  Future<void> fetchDepartamentos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/departamentos'));
    if (response.statusCode == 200) {
      setState(() {
        departamentos = json.decode(response.body);
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao carregar departamentos')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> curso = {
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'cargaHorariaSemestre': int.parse(_cargaHorariaSemestreController.text),
        'cargaHorariaTotal': int.parse(_cargaHorariaTotalController.text),
        'numeroSemestres': int.parse(_numeroSemestresController.text),
        'nivel': _nivelController.text,
        'departamentoid': _selectedDepartamentoId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = widget.curso == null
          ? Uri.parse('http://localhost:3000/api/cursos')
          : Uri.parse('http://localhost:3000/api/cursos/${widget.curso!['id']}');

      final response = widget.curso == null
          ? await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(curso))
          : await http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(curso));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.curso == null ? 'Curso inserido com sucesso!' : 'Curso atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar curso')),
        );
      }
    }
  }

  Future<void> _deleteCurso(int id) async {
    final url = Uri.parse('http://localhost:3000/api/cursos/$id');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Curso deletado com sucesso!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar curso')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _cargaHorariaSemestreController.dispose();
    _cargaHorariaTotalController.dispose();
    _numeroSemestresController.dispose();
    _nivelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.curso == null ? 'Adicionar Curso' : 'Editar Curso'),
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
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cargaHorariaSemestreController,
                decoration: const InputDecoration(labelText: 'Carga Horária Semestre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a carga horária por semestre';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _cargaHorariaTotalController,
                decoration: const InputDecoration(labelText: 'Carga Horária Total'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a carga horária total';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _numeroSemestresController,
                decoration: const InputDecoration(labelText: 'Número de Semestres'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o número de semestres';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _nivelController,
                decoration: const InputDecoration(labelText: 'Nível'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o nível';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedDepartamentoId,
                onChanged: (value) {
                  setState(() {
                    _selectedDepartamentoId = value;
                  });
                },
                items: departamentos.map<DropdownMenuItem<int>>((departamento) {
                  return DropdownMenuItem<int>(
                    value: departamento['id'],
                    child: Text(departamento['nome']),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Departamento'),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um departamento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.curso == null ? 'Inserir' : 'Atualizar'),
              ),
              if (widget.curso != null)
                ElevatedButton(
                  onPressed: () => _deleteCurso(widget.curso!['id']),
                  child: const Text('Deletar'),
                 // style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
