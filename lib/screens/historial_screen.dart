import 'package:birrawrapped/components/beer_entry_card.dart';
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/beers_service.dart';
import 'package:birrawrapped/components/edit_datetime_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({Key? key}) : super(key: key);

  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late Future<List<Map<String, dynamic>>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    _entriesFuture = _fetchEntries();
  }

  Future<List<Map<String, dynamic>>> _fetchEntries() async {
    final userId = context.read<UserProvider>().getUserId();

    final date = DateTime.now().subtract(const Duration(days: 3));
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return BeersService().getLast3DaysUserBeers(userId.toString(), dateStr);
  }

  Future<void> _deleteEntry(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text('Eliminar entrada'),
        content: const Text('Estàs segur que vols eliminar aquesta entrada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel·lar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final userId = context.read<UserProvider>().getUserId();
      await BeersService().deleteUserBeer(userId.toString(), id.toString());
      print('Eliminar beer amb Id: $id');
      setState(() => _loadEntries());
    }
  }

  Future<void> _editEntryDateTime(Map<String, dynamic> entry) async {
    final userId = context.read<UserProvider>().getUserId();

    final currentDate =
        DateTime.tryParse(entry['date'] ?? '') ?? DateTime.now();
    TimeOfDay currentTime = TimeOfDay.now();
    final timeStr = entry['time'] as String?;
    if (timeStr != null && timeStr.contains(':')) {
      final parts = timeStr.split(':');
      currentTime = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    await showDialog(
      context: context,
      builder: (ctx) => EditDateTimeDialog(
        initialDate: currentDate,
        initialTime: currentTime,
        onSave: (newDate, newTime) async {
          final dateStr =
              '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';
          final timeStrFormatted =
              '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
          const catalanDays = [
            'Dilluns',
            'Dimarts',
            'Dimecres',
            'Dijous',
            'Divendres',
            'Dissabte',
            'Diumenge'
          ];
          final dayOfWeek = catalanDays[newDate.weekday - 1];

          try {
            await BeersService().updateBeerToUser(
              userId.toString(),
              entry['id'].toString(),
              dateStr,
              timeStrFormatted,
              dayOfWeek,
            );
            if (mounted) setState(() => _loadEntries());
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error en actualitzar la data/hora')),
            );
          }
        },
      ),
    );
  }

  void _showEntryOptions(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFEDE4D3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFFB5884C)),
              title: const Text(
                'Modificar data i hora',
                style: TextStyle(fontFamily: 'Kameron'),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _editEntryDateTime(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Eliminar entrada',
                style: TextStyle(fontFamily: 'Kameron', color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _deleteEntry(entry['id']);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(
      List<Map<String, dynamic>> entries) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final entry in entries) {
      grouped.putIfAbsent(entry['date'], () => []).add(entry);
    }
    // Ordenem per hora dins cada dia
    for (final key in grouped.keys) {
      grouped[key]!
          .sort((a, b) => (b['time'] as String).compareTo(a['time'] as String));
    }
    return grouped;
  }

  // Funció per formatar la data
  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final months = [
      '',
      'gener',
      'febrer',
      'març',
      'abril',
      'maig',
      'juny',
      'juliol',
      'agost',
      'setembre',
      'octubre',
      'novembre',
      'desembre'
    ];
    return '${date.day} de ${months[date.month]} del ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSmallTitle(text: "Últims 3 dies"),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _entriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 48, color: Colors.red),
                                const SizedBox(height: 8),
                                Text(
                                  'Error carregant l\'historial\n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() => _loadEntries()),
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          );
                        }

                        final entries = snapshot.data!;

                        if (entries.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hi ha entrades dels últims 3 dies',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final grouped = _groupByDate(entries);
                        final dates = grouped.keys.toList()
                          ..sort((a, b) => b.compareTo(a));

                        return ListView.builder(
                          itemCount: dates.length,
                          itemBuilder: (context, index) {
                            final date = dates[index];
                            final dayEntries = grouped[date]!;
                            final dayOfWeek = dayEntries.first['dayOfWeek'];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB5884C),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${dayEntries.first['dayOfWeek']} · ${_formatDate(dayEntries.first['date'])}',
                                      style: const TextStyle(
                                        fontFamily: 'Kameron',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                ...dayEntries.map((entry) => GestureDetector(
                                      onLongPress: () =>
                                          _showEntryOptions(entry),
                                      child: BeerEntryCard(
                                        entry: entry,
                                      ),
                                    ))
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
