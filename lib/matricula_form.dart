import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MatriculaForm extends StatefulWidget {
  final Map<String, dynamic>? matricula;

  const MatriculaForm({super.key, this.matricula});

  @override
  // ignore: library_private_types_in_public_api
  _MatriculaFormState createState() => _MatriculaFormState();
}

class _MatriculaFormState extends State<MatriculaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notaFinalController = TextEditingController();
  final TextEditingController _numeroPresencasController = TextEditingController();
  final TextEditingController _numeroFaltasController = TextEditingController();
  int? _selectedDisciplinaId;

  @override
  void initState() {
    super.initState();
    if (widget.matricula != null) {
      _notaFinalController.text = widget.matricula!['notaFinal'].toString();
      _numeroPresencasController.text = widget.matricula!['numeroPresencas'].toString();
      _numeroFaltasController.text = widget.matricula!['numeroFaltas'].toString();
      _selectedDisciplinaId = widget.matricula!['disciplinaId'];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> matricula = {
        'notaFinal': double.parse(_notaFinalController.text),
        'numeroPresencas': int.parse(_numeroPresencasController.text),
        'numeroFaltas': int.parse(_numeroFaltasController.text),
        'disciplinaId': _selectedDisciplinaId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = widget.matricula == null
          ? Uri.parse('http://localhost:3000/api/matriculas')
          : Uri.parse('http://localhost:3000/api/matriculas/${widget.matricula!['id']}');

      final response = widget.matricula == null
          ? await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(matricula))
          : await http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(matricula));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.matricula == null ? 'Matrícula inserida com sucesso!' : 'Matrícula atualizada com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar matrícula')),
        );
      }
    }
  }

  @override
  void dispose() {
    _notaFinalController.dispose();
    _numeroPresencasController.dispose();
    _numeroFaltasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.matricula == null ? 'Adicionar Matrícula' : 'Editar Matrícula'),
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a nota final';
                  }
                  return null;
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                controller: _numeroPresencasController,
                decoration: const InputDecoration(labelText: 'Número de Presenças'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o número de presenças';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _numeroFaltasController,
                decoration: const InputDecoration(labelText: 'Número de Faltas'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o número de faltas';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              // Adicione um campo para selecionar a disciplina, se necessário
              // DropdownButtonFormField(
              //   value: _selectedDisciplinaId,
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedDisciplinaId = value as int?;
              //     });
              //   },
              //   items: [
              //     // Adicione itens de dropdown aqui
              //   ],
              //   decoration: InputDecoration(labelText: 'Disciplina'),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.matricula == null ? 'Inserir' : 'Atualizar'),
              ),
              if (widget.matricula != null)
                ElevatedButton(
                  onPressed: () => _deleteMatricula(widget.matricula!['id']),
                  child: const Text('Deletar'),
                  //style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMatricula(int matriculaId) async {
    final url = Uri.parse('http://localhost:3000/api/matriculas/$matriculaId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Matrícula deletada com sucesso!')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar matrícula')),
      );
    }
  }
}
