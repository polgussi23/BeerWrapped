import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/components/drink_card.dart';
import 'package:birrawrapped/models/beers_response.dart';
import 'package:birrawrapped/services/beers_service.dart';
import 'package:birrawrapped/services/preferences_service.dart';
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
      BeersService().getAllBeers(),
      PreferencesService.getBeerHistory(),
    ]);

    _beerHistory = results[1] as List<int>;
    return results[0] as BeersResponse;
  }

  void _onDrinkSelected(Beer beer) async {
    await PreferencesService.saveBeerToHistory(beer.id);
    print('Beguda seleccionada: ${beer.name}. Enllaç imatge: ${beer.imageUrl}');

    var userId = context.read<UserProvider>().getUserId().toString();
    var beerId = beer.id.toString();
    var now = DateTime.now();
    var date = "${now.year}-${now.month}-${now.day}";
    var time = "${now.hour}:${now.minute}:${now.second}";
    var numOfWeek = now.weekday;
    var dayOfWeek = daysOfWeek[numOfWeek - 1];

    BeersService().postBeerToUser(userId, beerId, date, time, dayOfWeek);

    Navigator.pop(context);
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
                        // Carregant
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Error
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline,
                                    size: 48, color: Colors.red),
                                const SizedBox(height: 8),
                                Text(
                                  'Error carregant les begudes\n${snapshot.error}',
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

                        // Dades carregades
                        final beers = snapshot.data!.beers;

                        if (_beerHistory.isNotEmpty) {
                          beers.sort((a, b) {
                            final indexA = _beerHistory.indexOf(a.id);
                            final indexB = _beerHistory.indexOf(b.id);

                            // Si no està a l'historial, va al final
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
                            /*
                            if (index == beers.length) {
                              return DrinkCard(
                                text: 'Afegeix',
                                imageAsset: 'assets/images/altres.png',
                                onTap: () =>
                                    Navigator.pushNamed(context, '/crea_beer'),
                              );
                            }
                            */
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
