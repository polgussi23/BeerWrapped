class Beer {
  final int id;
  final String name;
  final String imageUrl;

  Beer({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

class BeersResponse {
  final List<Beer> beers;

  BeersResponse({
    required this.beers,
  });

  factory BeersResponse.fromJson(Map<String, dynamic> json) {
    return BeersResponse(
      beers: (json['beers'] as List)
          .map((beerJson) => Beer.fromJson(beerJson))
          .toList(),
    );
  }
}
