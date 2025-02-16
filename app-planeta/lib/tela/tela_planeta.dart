import 'package:flutter/material.dart';
import 'package:myapp/controles/controle-planeta.dart';
import 'package:myapp/modelos/planetas.dart';

class TelaPlaneta extends StatefulWidget {
  final Function() onFinalizado;
  final bool isIncluir;
  final Planeta planeta;
  const TelaPlaneta(
      {super.key,
      required this.isIncluir,
      required this.planeta,
      required this.onFinalizado});

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Dados do planeta ${widget.isIncluir ? 'Incluidos' : 'alterados'} com sucesso!'),
        ),
      );
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 2) {
                        return 'Por favor, insira o nome do planeta (pelo menos 2 caracteres)';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _planeta.nome = value!;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _tamanhoController,
                      decoration: InputDecoration(
                        labelText: 'Tamanho (Km)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o tamanho do planeta';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Insira um valor numérico válido.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planeta.distancia = double.parse(value!);
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _distanciaController,
                      decoration: InputDecoration(
                        labelText: 'Distância (Km)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a distnância do planeta';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Insira um valor numérico válido.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _planeta.distancia = double.parse(value!);
                      }),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _apelidoController,
                      decoration: InputDecoration(
                        labelText: 'Apelido',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onSaved: (value) {
                        _planeta.apelido = value;
                      }),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed:() => Navigator.of(context).pop(), child: const Text('Cancelar')),
                      ElevatedButton(
                          onPressed: _submitForm, child: const Text('Salvar'))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}