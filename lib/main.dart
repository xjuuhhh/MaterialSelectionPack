import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agendamento de Evento",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 252, 7, 7)),
        useMaterial3: true,
      ),
      // Aponta Home para Classe AgendamentoEventoTela
      home: const AgendamentoEventoTela(),
    );
  }
}

class AgendamentoEventoTela extends StatefulWidget {
  const AgendamentoEventoTela({super.key});

  @override
  State<AgendamentoEventoTela> createState() => _AgendamentoEventoTelaState();
}


class _AgendamentoEventoTelaState extends State<AgendamentoEventoTela> {
  //--- 1. Valores Padrão (para reset) ---
  static final DateTime _dataPadrao = DateTime.now();
  static const TimeOfDay _horarioPadrao = TimeOfDay(hour: 19, minute:0);

  // ---2.Variaveis de Estado ---
  late DateTime _dataSelecionada;
  late TimeOfDay _horarioSelecionado;

  @override
  void initState() {
    super.initState();
    _resetarValores();
  } 

  void _resetarValores() {
    setState(() {
      _dataSelecionada = _dataPadrao;
      _horarioSelecionado = _horarioPadrao;
    });
    print('[DEBUG] Formulario resetado para os valores padrao.');
  }

  void _salvarformulario() {
    print('=====================================');
    print('        RESUMO DO AGENDAMENTO        ');
    print('=====================================');
    print(
      'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}'
      );
    print('=====================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evento salvo com sucesso! Veja os logs no console.'),
      ),
      
      );   
  }

  //---Funções Auxiliares para Pickers ---
  Future<void> _selecionarData(BuildContext context) async{
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),      
    );
    if (data != null && data != _dataSelecionada) {
      setState(() {
        _dataSelecionada = data;
      });
      print('[DEBUG - DataPicker] Data selecionada: $data');
    }
  }

  Future<void> _selecionarHorario (BuildContext context) async{
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado,
      );
      if (horario != null && horario != _horarioSelecionado) {
        setState(() {
          _horarioSelecionado = horario;
        });
        print(
          '[DEBUG - TimePicker] Horário selecionado: ${horario.format(context)}'
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Evento Social'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. DatePicker & 2. TimePicker ---
            Text(
              'Data e Horario',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      '${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                    ),
                    onPressed: () => _selecionarData(context),
                ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon:const Icon(Icons.access_time),
                    label: Text(_horarioSelecionado.format(context)),
                    onPressed: () => _selecionarHorario(context),
                    ),
                    ),
              ],
              ),
              const Divider(height:32),
          ],
        )
      ),
    );
  }
}