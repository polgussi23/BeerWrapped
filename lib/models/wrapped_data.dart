class SeasonCount {
  final String season;
  final int count;

  SeasonCount({required this.season, required this.count});

  factory SeasonCount.fromJson(Map<String, dynamic> j) =>
      SeasonCount(season: j['season'] as String, count: j['count'] as int);
}

class MonthCount {
  final int month;
  final int year;
  final int count;

  MonthCount({required this.month, required this.year, required this.count});

  factory MonthCount.fromJson(Map<String, dynamic> j) => MonthCount(
        month: j['month'] as int,
        year: j['year'] as int,
        count: j['count'] as int,
      );
}

class BeerTypeCount {
  final String name;
  final int count;

  BeerTypeCount({required this.name, required this.count});

  factory BeerTypeCount.fromJson(Map<String, dynamic> j) =>
      BeerTypeCount(name: j['name'] as String, count: j['count'] as int);
}

class MomentCount {
  final String moment;
  final int count;

  MomentCount({required this.moment, required this.count});

  factory MomentCount.fromJson(Map<String, dynamic> j) =>
      MomentCount(moment: j['moment'] as String, count: j['count'] as int);
}

class WrappedData {
  // Totals
  final int totalBeers;
  final double totalLiters;

  // Birra favorita
  final String? favBeerName;
  final int? favBeerCount;
  final double? favBeerPct;

  // Temps
  final String? avgTime;
  final String? earliestBeer;
  final String? latestBeer;

  // Dies i setmanes
  final String? bestDayOfWeek;
  final int? bestDayCount;
  final String? peakDay;
  final int? peakDayCount;
  final String? bestWeekStart;
  final int? bestWeekCount;

  // Mes i ratxa
  final int? bestMonth;
  final int? bestMonthYear;
  final int? bestMonthCount;
  final int maxStreak;

  // Evolució
  final int firstHalf;
  final int secondHalf;
  final String trend; // 'up' | 'down'
  final List<SeasonCount> beersBySeason;
  final String? bestSeason;
  final int? bestSeasonCount;

  // Grup
  final String? bestGroupName;
  final int? bestGroupCount;

  // Charts
  final List<MonthCount> beersByMonth;
  final List<BeerTypeCount> beersByType;
  final List<MomentCount> beersByMoment;

  // Highlights narratius
  final List<String> highlights;

  WrappedData({
    required this.totalBeers,
    required this.totalLiters,
    this.favBeerName,
    this.favBeerCount,
    this.favBeerPct,
    this.avgTime,
    this.earliestBeer,
    this.latestBeer,
    this.bestDayOfWeek,
    this.bestDayCount,
    this.peakDay,
    this.peakDayCount,
    this.bestWeekStart,
    this.bestWeekCount,
    this.bestMonth,
    this.bestMonthYear,
    this.bestMonthCount,
    required this.maxStreak,
    required this.firstHalf,
    required this.secondHalf,
    required this.trend,
    required this.beersBySeason,
    this.bestSeason,
    this.bestSeasonCount,
    this.bestGroupName,
    this.bestGroupCount,
    required this.beersByMonth,
    required this.beersByType,
    required this.beersByMoment,
    required this.highlights,
  });

  factory WrappedData.fromJson(Map<String, dynamic> w) {
    final totals = w['totals'] as Map<String, dynamic>;
    final fav = w['favBeer'] as Map<String, dynamic>?;
    final bestDay = w['bestDayOfWeek'] as Map<String, dynamic>?;
    final bestM = w['bestMonth'] as Map<String, dynamic>?;
    final evo = w['evolution'] as Map<String, dynamic>;
    final rec = w['records'] as Map<String, dynamic>;
    final peak = rec['peakDay'] as Map<String, dynamic>?;
    final week = rec['bestWeek'] as Map<String, dynamic>?;
    final grp = w['bestGroup'] as Map<String, dynamic>?;
    final charts = w['charts'] as Map<String, dynamic>;
    final bestSeasonRaw = evo['bestSeason'] as Map<String, dynamic>?;

    return WrappedData(
      totalBeers: totals['totalBeers'] as int,
      totalLiters: double.tryParse(totals['totalLiters'].toString()) ?? 0,
      favBeerName: fav?['name'] as String?,
      favBeerCount: fav?['count'] as int?,
      favBeerPct: double.tryParse(fav?['percentage']?.toString() ?? ''),
      avgTime: w['avgTime'] as String?,
      earliestBeer: rec['earliestBeer'] as String?,
      latestBeer: rec['latestBeer'] as String?,
      bestDayOfWeek: bestDay?['day'] as String?,
      bestDayCount: bestDay?['count'] as int?,
      peakDay: peak?['date'] as String?,
      peakDayCount: peak?['count'] as int?,
      bestWeekStart: week?['weekStart'] as String?,
      bestWeekCount: week?['count'] as int?,
      bestMonth: bestM?['month'] as int?,
      bestMonthYear: bestM?['year'] as int?,
      bestMonthCount: bestM?['count'] as int?,
      maxStreak: w['maxStreak'] as int? ?? 0,
      firstHalf: evo['firstHalf'] as int,
      secondHalf: evo['secondHalf'] as int,
      trend: evo['trend'] as String? ?? 'up',
      beersBySeason: (evo['beersBySeason'] as List)
          .map((e) => SeasonCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      bestSeason: bestSeasonRaw?['season'] as String?,
      bestSeasonCount: bestSeasonRaw?['count'] as int?,
      bestGroupName: grp?['name'] as String?,
      bestGroupCount: grp?['count'] as int?,
      beersByMonth: (charts['beersByMonth'] as List)
          .map((e) => MonthCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      beersByType: (charts['beersByType'] as List)
          .map((e) => BeerTypeCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      beersByMoment: (charts['beersByMoment'] as List)
          .map((e) => MomentCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      highlights: (w['highlights'] as List).map((e) => e as String).toList(),
    );
  }
}
