import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dao/eventdao.dart';
import '../dao/saledao.dart';
import '../models/event.dart';
import '../models/sale.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late Event _currentEvent;
  final EventDao _eventDao = EventDao();
  final SaleDao _saleDao = SaleDao();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _showSellTicketDialog() {
    _nameController.clear();
    _dobController.clear();
    _quantityController.text = '1';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Venda'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Comprador',
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Campo obrigatório.'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Nascimento',
                      hintText: 'DD/MM/AAAA',
                    ),
                    readOnly: true,
                    onTap: _selectDate,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Campo obrigatório.'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade de Ingressos',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório.';
                      }
                      final quantity = int.tryParse(value);
                      if (quantity == null || quantity <= 0)
                        return 'Quantidade inválida.';
                      if (quantity > _currentEvent.ticketQuantidade)
                        return 'Não há ingressos suficientes.';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _confirmSale,
              child: const Text('Confirmar Venda'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  void _confirmSale() async {
    if (_formKey.currentState!.validate()) {
      final sale = Sale(
        compradorNome: _nameController.text,
        compradorNasc: _dobController.text,
        quantidadeVendida: int.parse(_quantityController.text),
        eventId: _currentEvent.id!,
      );

      // Salva a venda no banco
      await _saleDao.createSale(sale);

      // Atualiza a quantidade de ingressos do evento
      final updatedEvent = Event(
        id: _currentEvent.id,
        name: _currentEvent.name,
        ticketQuantidade:
            _currentEvent.ticketQuantidade - sale.quantidadeVendida,
      );
      await _eventDao.updateEvent(updatedEvent);

      // Atualiza o estado da tela e fecha o diálogo
      setState(() {
        _currentEvent = updatedEvent;
      });
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_currentEvent.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ingressos Restantes:',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                _currentEvent.ticketQuantidade.toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      _currentEvent.ticketQuantidade > 0
                          ? Colors.tealAccent
                          : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.sell),
                  label: const Text('Vender Ingresso'),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    disabledBackgroundColor: Colors.grey[700],
                  ),
                  onPressed:
                      _currentEvent.ticketQuantidade > 0
                          ? _showSellTicketDialog
                          : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
