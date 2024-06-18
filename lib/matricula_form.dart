import 'package:flutter/material.dart';
import 'matricula_form.dart'; // Importe o formulário de Matrícula

class MatriculaForm extends StatelessWidget {
  const MatriculaForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Matrículas'),
      ),
      body: const Center(
        child: Text('Exibição da lista de matrículas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatriculaForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
