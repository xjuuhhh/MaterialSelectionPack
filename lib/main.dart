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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 252, 7, 7),
        ),
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

enum Visibilidade { public, private, vip }

class _AgendamentoEventoTelaState extends State<AgendamentoEventoTela> {
  //--- 1. Valores Padrão (para reset) ---
  static final DateTime _dataPadrao = DateTime.now();
  static const TimeOfDay _horarioPadrao = TimeOfDay(hour: 19, minute: 0);
  static const String _tipoPadrao = 'Aniversario';
  static const double _convidadosPadrao = 50.0;
  static const Visibilidade _visibilidadePadrao = .private;

  static const Map<String, bool> _servicosPadrao = {
    'Buffet': false,
    'Fotógrafo': false,
    'Decoracao': false,
    'DJ': false,
  };

  static const List<String> _tagsDisponiveis = [
    'Vegetariano',
    'Sem Glúten',
    'Sem Lactose',
    'Vegano',
  ];

  static const List<String> _tagsPadrao = [];
  static const bool _lembretePadrao = true;

  // ---2.Variaveis de Estado ---
  late DateTime _dataSelecionada;
  late TimeOfDay _horarioSelecionado;
  late String _tipoEventoSelecionado;
  late double _quantidadeConvidados;
  late Visibilidade _visibilidadeSelecionada;
  late Map<String, bool> _servicosSelecionados;
  late List<String> _tagsSelecionadas;
  late bool _notificacaoAtiva;

  @override
  void initState() {
    super.initState();
    _resetarValores();
  }

  void _resetarValores() {
    setState(() {
      _dataSelecionada = _dataPadrao;
      _horarioSelecionado = _horarioPadrao;
      _tipoEventoSelecionado = _tipoPadrao;
      _quantidadeConvidados = _convidadosPadrao;
      _visibilidadeSelecionada = _visibilidadePadrao;
      _servicosSelecionados = Map<String, bool>.from(_servicosPadrao);
      _tagsSelecionadas = List<String>.from(_tagsPadrao);
      _notificacaoAtiva = _lembretePadrao;
    });
    print('[DEBUG] Formulario resetado para os valores padrao.');
  }

  void _salvarformulario() {
    print('=====================================');
    print('        RESUMO DO AGENDAMENTO        ');
    print('=====================================');
    print(
      'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
    );
    print('Horário: ${_horarioSelecionado.format(context)}');
    print('Tipo de evento: $_tipoEventoSelecionado');
    print('Estimativa de Convidados: ${_quantidadeConvidados.round()}');
    print('Visibilidade: $_visibilidadeSelecionada');
    print('Serviços Adicionais: $_servicosSelecionados');
    print('Restrições Alimentares (Tags): $_tagsSelecionadas');
    print('Lembrete Automatico: $_notificacaoAtiva');
    print('=====================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evento salvo com sucesso! Veja os logs no console.'),
      ),
    );
  }

  //---Funções Auxiliares para Pickers ---
  Future<void> _selecionarData(BuildContext context) async {
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

  Future<void> _selecionarHorario(BuildContext context) async {
    final TimeOfDay? horario = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado,
    );
    if (horario != null && horario != _horarioSelecionado) {
      setState(() {
        _horarioSelecionado = horario;
      });
      print(
        '[DEBUG - TimePicker] Horário selecionado: ${horario.format(context)}',
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
        child: Column(
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
                    icon: const Icon(Icons.access_time),
                    label: Text(_horarioSelecionado.format(context)),
                    onPressed: () => _selecionarHorario(context),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // --- 3. Menu (DropdownButton)
            Text(
              'Tipo de Evento',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _tipoEventoSelecionado,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: ['Aniversario', 'Casamento', 'Corporativo', 'Outro']
                  .map(
                    (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
                  )
                  .toList(),
              onChanged: (novoValor) {
                if (novoValor != null) {
                  setState(() {
                    _tipoEventoSelecionado = novoValor;
                  });
                  print(
                    '[DEBUG - Menu] Tipo de evento selecionado: $novoValor',
                  );
                }
              },
            ),
            const Divider(height: 32),

            // --- 4. Slider ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantidade de Convidados',
                  style: Theme.of(context).textTheme.titleMedium,
                ), // Text
                Text(
                  '${_quantidadeConvidados.round()} pessoas',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Slider(
              value: _quantidadeConvidados,
              min: 10,
              max: 500,
              divisions: 49,
              label: _quantidadeConvidados.round().toString(),
              onChanged: (novoValor) {
                setState(() {
                  _quantidadeConvidados = novoValor;
                });
                print(
                  '[DEBUG - Slider] Quantidade de convidados: ${novoValor.round()}',
                );
              },
            ),
            const Divider(height: 32),

            // --- 5. Radio ---
            Text(
              'Visibilidade do Evento',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            RadioGroup<Visibilidade>(
              groupValue: _visibilidadeSelecionada,
              onChanged: (Visibilidade? visibilidade) {
                setState(() {
                  _visibilidadeSelecionada = visibilidade!;
                  print('[DEBUG - Radio] Visibilidade: $visibilidade');
                });
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text('Público'),
                    leading: Radio<Visibilidade>(value: Visibilidade.public),
                  ),

                  ListTile(
                    title: Text('Privado'),
                    leading: Radio<Visibilidade>(value: Visibilidade.private),
                  ),

                  ListTile(
                    title: Text('Apenas Convidados'),
                    leading: Radio<Visibilidade>(value: Visibilidade.vip),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            // --- 6. Checkbox
            Text(
              'Serviços Adicionais',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Column(
              children: _servicosSelecionados.keys.map((servico) {
                return CheckboxListTile(
                  dense: true,
                  title: Text(servico),
                  value: _servicosSelecionados[servico],
                  onChanged: (bool? marcado) {
                    setState(() {
                      _servicosSelecionados[servico] = marcado ?? false;
                    });
                    print(
                      '[DEBUG - Checkbox] Servico "$servico" alterado para: $marcado',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),

            // --- 7. Chip (FilterChip)
            Text(
              'Restrições Alimentares (Tags)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _tagsDisponiveis.map((tag) {
                final estaSelecionado = _tagsSelecionadas.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: estaSelecionado,
                  onSelected: (bool selecionado) {
                    setState(() {
                      if (selecionado) {
                        _tagsSelecionadas.add(tag);
                      } else {
                        _tagsSelecionadas.remove(tag);
                      }
                    });
                    print(
                      '[DEBUG - Chip] Tag "$tag" ${selecionado ? "adicionada" : "removida"}. Lista atual: $_tagsSelecionadas',
                    );
                  },
                );
              }).toList(),
            ),
            const Divider(height: 32),

            // --- 8. Switch
            SwitchListTile(
              title: const Text('Enviar Lembrete Automatico'),
              subtitle: const Text(
                'Notificar convidados 24 horas antes do evento',
              ),
              value: _notificacaoAtiva,
              onChanged: (bool ativo) {
                setState(() {
                  _notificacaoAtiva = ativo;
                });
                print(
                  '[DEBUG - Switch] Notificacao automatica alterada para: $ativo',
                );
              },
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}
