import 'package:app_escola/curso_list.dart';
import 'package:flutter/material.dart';
import 'aluno_list.dart';
import 'professor_list.dart';
import 'matricula_list.dart';
import 'departamento_list.dart';
import 'disciplina_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro escolar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color.fromARGB(255, 209, 182, 243), // Cor de fundo da AppBar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Cor de fundo do BottomNavigationBar
          selectedItemColor:
              Color.fromARGB(255, 165, 140, 199), // Cor do item selecionado
          unselectedItemColor: Colors.white, // Cor dos itens não selecionados
          showSelectedLabels: true, // Mostrar rótulos dos itens selecionados
          showUnselectedLabels:
              true, // Mostrar rótulos dos itens não selecionados
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const AlunoList(),
    const ProfessorList(),
    const MatriculaList(),
    const CursoList(),
    const DepartamentoList(),
    const DisciplinaList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SISTEMA ESCOLAR'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Alunos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.school,
              color: Colors.blue,
            ),
            label: 'Professores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Matrículas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Departamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Disciplinas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
      ),
    );
  }
}
