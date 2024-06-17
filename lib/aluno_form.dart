import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AlunoForm extends StatefulWidget {
  final Map<String, dynamic>? aluno;

  const AlunoForm({super.key, this.aluno});

  @override
  // ignore: library_private_types_in_public_api
  _AlunoFormState createState() => _AlunoFormState();
}

class _AlunoFormState extends State<AlunoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _enderecoAtualController = TextEditingController();
  final TextEditingController _telefonesController = TextEditingController();
  final TextEditingController _enderecoPermanenteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  int? _selectedCursoId;

  @override
  void initState() {
    super.initState();
    if (widget.aluno != null) {
      _nomeController.text = widget.aluno!['nome'];
      _numeroController.text = widget.aluno!['numero'];
      _cpfController.text = widget.aluno!['cpf'];
      _rgController.text = widget.aluno!['rg'];
      _enderecoAtualController.text = widget.aluno!['enderecoatual'];
      _telefonesController.text = widget.aluno!['telefones'];
      _enderecoPermanenteController.text = widget.aluno!['enderecopermanente'];
      _emailController.text = widget.aluno!['email'];
      _dataNascimentoController.text = widget.aluno!['datanascimento'];
      _sexoController.text = widget.aluno!['sexo'];
      _selectedCursoId = widget.aluno!['cursoId'];
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> aluno = {
        'nome': _nomeController.text,
        'numero': _numeroController.text,
        'cpf': _cpfController.text,
        'rg': _rgController.text,
        'enderecoatual': _enderecoAtualController.text,
        'telefones': _telefonesController.text,
        'enderecopermanente': _enderecoPermanenteController.text,
        'email': _emailController.text,
        'datanascimento': _dataNascimentoController.text,
        'sexo': _sexoController.text,
        'cursoId': _selectedCursoId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final url = widget.aluno == null
          ? Uri.parse('http://localhost:3000/api/alunos')
          : Uri.parse('http://localhost:3000/api/alunos/${widget.aluno!['id']}');

      final response = widget.aluno == null
          ? await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(aluno))
          : await http.put(url, headers: {'Content-Type': 'application/json'}, body: json.encode(aluno));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.aluno == null ? 'Aluno inserido com sucesso!' : 'Aluno atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar aluno')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroController.dispose();
    _cpfController.dispose();
    _rgController.dispose();
    _enderecoAtualController.dispose();
    _telefonesController.dispose();
    _enderecoPermanenteController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _sexoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.aluno == null ? 'Adicionar Aluno' : 'Editar Aluno'),
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
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Número'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o número';
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
                controller: _rgController,
                decoration: const InputDecoration(labelText: 'RG'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o RG';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoAtualController,
                decoration: const InputDecoration(labelText: 'Endereço Atual'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o endereço atual';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonesController,
                decoration: const InputDecoration(labelText: 'Telefones'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira os telefones';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _enderecoPermanenteController,
                decoration: const InputDecoration(labelText: 'Endereço Permanente'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o endereço permanente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data de nascimento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sexoController,
                decoration: const InputDecoration(labelText: 'Sexo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o sexo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.aluno == null ? 'Inserir' : 'Atualizar'),
              ),
              if (widget.aluno != null)
                ElevatedButton(
                  onPressed: () => _deleteAluno(widget.aluno!['id']),
                  child: const Text('Deletar'),
                 // style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAluno(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/api/alunos/$id'));
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aluno deletado com sucesso!')));
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falha ao deletar aluno')));
    }
  }
}
