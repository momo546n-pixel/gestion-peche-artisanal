class FishingTrip {
  final String id;
  final String pirogue;
  final String species;
  final double quantityKg;
  final int pricePerKg;
  final DateTime date;

  const FishingTrip({
    required this.id,
    required this.pirogue,
    required this.species,
    required this.quantityKg,
    required this.pricePerKg,
    required this.date,
  });

  /// Revenu calculé automatiquement
  double get revenue => quantityKg * pricePerKg;

  /// Pour modifier une sortie existante
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