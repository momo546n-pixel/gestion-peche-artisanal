import 'package:hive/hive.dart';

part 'fishing_trip.g.dart';

@HiveType(typeId: 0)
class FishingTrip extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pirogue;

  @HiveField(2)
  final String species;

  @HiveField(3)
  final double quantityKg;

  @HiveField(4)
  final int pricePerKg;

  @HiveField(5)
  final DateTime date;

  FishingTrip({
    required this.id,
    required this.pirogue,
    required this.species,
    required this.quantityKg,
    required this.pricePerKg,
    required this.date,
  });

  double get revenue => quantityKg * pricePerKg;

  FishingTrip copyWith({
    String? id,
    String? pirogue,
    String? species,
    double? quantityKg,
    int? pricePerKg,
    DateTime? date,
  }) {
    return FishingTrip(
      id: id ?? this.id,
      pirogue: pirogue ?? this.pirogue,
      species: species ?? this.species,
      quantityKg: quantityKg ?? this.quantityKg,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      date: date ?? this.date,
    );
  }
}