import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dao/eventdao.dart';
import '../models/event.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final EventDao _eventDao = EventDao();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final quantity = int.parse(_quantityController.text);

      final newEvent = Event(name: name, ticketQuantidade: quantity);

      await _eventDao.createEvent(newEvent);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Novo Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Evento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do evento.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Idade Mínima',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Idade Minima.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de Ingressos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade de ingressos.';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Por favor, insira um número válido e maior que zero.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveEvent,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Evento'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor:
                      Theme.of(
                        context,
                      ).floatingActionButtonTheme.backgroundColor,
                  foregroundColor:
                      Theme.of(
                        context,
                      ).floatingActionButtonTheme.foregroundColor,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
