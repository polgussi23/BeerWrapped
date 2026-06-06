// screens/chooseDrink_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/components/drink_card.dart';
import 'package:birrawrapped/models/beers_response.dart';
import 'package:birrawrapped/services/beers_service.dart';
import 'package:birrawrapped/services/preferences_service.dart';
import 'package:birrawrapped/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseDrinkScreen extends StatefulWidget {
  const ChooseDrinkScreen({Key? key}) : super(key: key);

  @override
  _ChooseDrinkScreenState createState() => _ChooseDrinkScreenState();
}

class _ChooseDrinkScreenState extends State<ChooseDrinkScreen> {
  late Future<BeersResponse> _beersFuture;
  List<int> _beerHistory = [];
  static const List<String> daysOfWeek = [
    'Dilluns',
    'Dimarts',
    'Dimecres',
    'Dijous',
    'Divendres',
    'Dissabte',
    'Diumenge'
  ];

  @override
  void initState() {
    super.initState();
    _beersFuture = getAllBeers();
  }

  Future<BeersResponse> getAllBeers() async {
    final results = await Future.wait([
      BeersService().getAllBeers(), // ara té cache offline integrat
      PreferencesService.getBeerHistory(),
    ]);

    _beerHistory = results[1] as List<int>;
    return results[0] as BeersResponse;
  }

  void _onDrinkSelected(Beer beer) async {
    await PreferencesService.saveBeerToHistory(beer.id);

    final userId = context.read<UserProvider>().getUserId().toString();
    final beerId = beer.id.toString();
    final now = DateTime.now();
    final date = "${now.year}-${now.month}-${now.day}";
    final time = "${now.hour}:${now.minute}:${now.second}";
    final dayOfWeek = daysOfWeek[now.weekday - 1];

    await BeersService().saveBeerLocally(userId, beerId, date, time, dayOfWeek);

    // Capturem el messenger ABANS del pop, mentre el context encara és vàlid
    final messenger = ScaffoldMessenger.of(context);

    Navigator.pop(context);

    Future.any([
      SyncService().syncPending(),
      Future.delayed(const Duration(seconds: 1), () => false),
    ]).then((synced) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(synced
              ? '🍺 Birra registrada!'
              : '📶 Sense connexió, es pujarà quan tornis a tenir-ne.'),
          duration: Duration(seconds: synced ? 2 : 4),
          backgroundColor: synced ? Colors.green[700] : Colors.orange[700],
        ),
      );
    });
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
                  CustomSmallTitle(text: "Què has begut?"),
                  const SizedBox(height: 8),
                  Expanded(
                    child: FutureBuilder<BeersResponse>(
                      future: _beersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off,
                                    size: 48, color: Colors.grey),
                                const SizedBox(height: 8),
                                const Text(
                                  'Sense connexió i sense dades en cache.\nConnecta\'t a internet per carregar les begudes.',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => setState(() {
                                    _beersFuture = getAllBeers();
                                  }),
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          );
                        }

                        final beers = snapshot.data!.beers;

                        if (_beerHistory.isNotEmpty) {
                          beers.sort((a, b) {
                            final indexA = _beerHistory.indexOf(a.id);
                            final indexB = _beerHistory.indexOf(b.id);
                            final posA = indexA == -1 ? 999 : indexA;
                            final posB = indexB == -1 ? 999 : indexB;
                            return posA.compareTo(posB);
                          });
                        }

                        if (beers.isEmpty) {
                          return const Center(
                            child: Text('No hi ha begudes disponibles'),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: beers.length,
                          itemBuilder: (context, index) {
                            final beer = beers[index];
                            return DrinkCard(
                              text: beer.name,
                              imageUrl: beer.imageUrl,
                              onTap: () => _onDrinkSelected(beer),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
