import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AlunoList extends StatefulWidget {
  const AlunoList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AlunoListState createState() => _AlunoListState();
}

class _AlunoListState extends State<AlunoList> {
  List<dynamic> _alunos = [];

  @override
  void initState() {
    _fetchAlunos();

    super.initState();
  }

  Future<void> _fetchAlunos() async {
    print("Fetch Studsts");
    final dio = Dio();
    const String myUril = 'http://192.168.0.123:3000/api/alunos';
    const String myUr = 'https://fakestoreapi.com/products';
    final url = Uri.parse(myUril);

    try {
      final response = await dio.get(myUril);

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("auiiiii");
        setState(() {
//_alunos = json.decode(response.data);
        });
      } else {
        // ignore: use_build_context_synchronously
        print("no else...");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao buscar alunos')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteAluno(int id) async {
    final url = Uri.parse('http://localhost:3000/api/alunos/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno deletado com sucesso!')),
      );
      _fetchAlunos();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao deletar aluno')),
      );
    }
  }

  void _editAluno(Map<String, dynamic> aluno) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlunoForm(aluno: aluno),
      ),
    ).then((_) {
      _fetchAlunos();
    });
  }

  void _addAluno() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AlunoForm(),
      ),
    ).then((_) {
      _fetchAlunos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAluno,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _alunos.length,
        itemBuilder: (context, index) {
          final aluno = _alunos[index];
          return ListTile(
            title: Text(aluno['nome']),
            subtitle: Text('Número: ${aluno['numero']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editAluno(aluno),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteAluno(aluno['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
  final TextEditingController _enderecoAtualController =
      TextEditingController();
  final TextEditingController _telefonesController = TextEditingController();
  final TextEditingController _enderecoPermanenteController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  int? _selectedCursoId;
  int? _selectedAlunoId;

  @override
  void initState() {
    super.initState();
    if (widget.aluno != null) {
      _selectedAlunoId = widget.aluno!['id'];
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

      final url = _selectedAlunoId == null
          ? Uri.parse('http://localhost:3000/api/alunos')
          : Uri.parse('http://localhost:3000/api/alunos/$_selectedAlunoId');

      final response = _selectedAlunoId == null
          ? await http.post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(aluno))
          : await http.put(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(aluno));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_selectedAlunoId == null
                  ? 'Aluno inserido com sucesso!'
                  : 'Aluno atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar aluno')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Alunos'),
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
                decoration:
                    const InputDecoration(labelText: 'Endereço Permanente'),
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
                decoration:
                    const InputDecoration(labelText: 'Data de Nascimento'),
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
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_selectedAlunoId == null
                    ? 'Adicionar Aluno'
                    : 'Atualizar Aluno'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
