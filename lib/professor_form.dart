import 'package:flutter/material.dart';
import 'professor_form.dart'; // Importe o formulário de Professor

class ProfessorForm extends StatelessWidget {
  const ProfessorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Professores'),
      ),
      body: const Center(
        child: Text('Exibição da lista de professores'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfessorForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
