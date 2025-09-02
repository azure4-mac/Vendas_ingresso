import 'package:flutter/material.dart';
import '../dao/eventdao.dart';
import '../models/event.dart';
import 'add_event.dart';
import 'event_detail.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final EventDao _eventDao = EventDao();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = _eventDao.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos Disponíveis'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar eventos: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum evento cadastrado.\nClique no botão + para adicionar um novo evento.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            );
          }

          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    'Ingressos restantes: ${event.ticketQuantidade}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event),
                      ),
                    );
                    _refreshEvents();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
          _refreshEvents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
