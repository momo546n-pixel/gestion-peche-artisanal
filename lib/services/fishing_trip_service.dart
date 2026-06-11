import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/fishing_trip.dart';

class FishingTripService extends ChangeNotifier {
  final _uuid = const Uuid();
  late Box<FishingTrip> _box;
  bool _initialized = false;

  static const List<String> availableSpecies = [
    'Thiof',
    'Yaboy',
    'Sardinelle',
    'Capitaine',
    'Dorade',
    'Maquereau',
  ];

  static const List<String> availablePirogues = [
    'Aminata',
    'Fatou Diagne',
    'Salam',
    'Bamba',
    'Ndeye',
  ];

  // ── Initialisation ────────────────────────────────────

  Future<void> init() async {
    _box = await Hive.openBox<FishingTrip>('fishing_trips');

    // Insere les données demo si la box est vide
    if (_box.isEmpty) {
      await _insertDemoData();
    }

    _initialized = true;
    notifyListeners();
  }

  Future<void> _insertDemoData() async {
    for (final trip in _demoData) {
      await _box.put(trip.id, trip);
    }
  }

  // ── Getters ───────────────────────────────────────────

  List<FishingTrip> get trips {
    if (!_initialized) return [];
    return _box.values.toList();
  }

  double get totalRevenue =>
      trips.fold(0, (sum, t) => sum + t.revenue);

  double get totalQuantity =>
      trips.fold(0, (sum, t) => sum + t.quantityKg);

  int get totalTrips => trips.length;

  // ── Filtres ───────────────────────────────────────────

  List<FishingTrip> filter({
    String? species,
    String? pirogue,
    DateTime? date,
    String? search,
  }) {
    return trips.where((t) {
      if (species != null && species.isNotEmpty && t.species != species) {
        return false;
      }
      if (pirogue != null && pirogue.isNotEmpty && t.pirogue != pirogue) {
        return false;
      }
      if (date != null &&
          (t.date.year != date.year ||
              t.date.month != date.month ||
              t.date.day != date.day)) {
        return false;
      }
      if (search != null && search.isNotEmpty) {
        final q = search.toLowerCase();
        if (!t.pirogue.toLowerCase().contains(q) &&
            !t.species.toLowerCase().contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // ── CRUD ──────────────────────────────────────────────

  Future<void> addTrip({
    required String pirogue,
    required String species,
    required double quantityKg,
    required int pricePerKg,
    required DateTime date,
  }) async {
    final trip = FishingTrip(
      id: _uuid.v4(),
      pirogue: pirogue,
      species: species,
      quantityKg: quantityKg,
      pricePerKg: pricePerKg,
      date: date,
    );
    await _box.put(trip.id, trip);
    notifyListeners();
  }

  Future<void> updateTrip(FishingTrip updated) async {
    await _box.put(updated.id, updated);
    notifyListeners();
  }

  Future<void> deleteTrip(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  FishingTrip? getById(String id) {
    return _box.get(id);
  }
}

// ── Données de démonstration ──────────────────────────────

final _demoData = [
  FishingTrip(
    id: 'demo-1',
    pirogue: 'Aminata',
    species: 'Thiof',
    quantityKg: 45.0,
    pricePerKg: 3500,
    date: DateTime(2025, 6, 1),
  ),
  FishingTrip(
    id: 'demo-2',
    pirogue: 'Fatou Diagne',
    species: 'Sardinelle',
    quantityKg: 120.0,
    pricePerKg: 800,
    date: DateTime(2025, 6, 3),
  ),
  FishingTrip(
    id: 'demo-3',
    pirogue: 'Salam',
    species: 'Capitaine',
    quantityKg: 30.5,
    pricePerKg: 2800,
    date: DateTime(2025, 6, 5),
  ),
  FishingTrip(
    id: 'demo-4',
    pirogue: 'Bamba',
    species: 'Dorade',
    quantityKg: 22.0,
    pricePerKg: 3200,
    date: DateTime(2025, 6, 7),
  ),
  FishingTrip(
    id: 'demo-5',
    pirogue: 'Aminata',
    species: 'Maquereau',
    quantityKg: 88.0,
    pricePerKg: 600,
    date: DateTime(2025, 6, 8),
  ),
  FishingTrip(
    id: 'demo-6',
    pirogue: 'Ndeye',
    species: 'Yaboy',
    quantityKg: 15.0,
    pricePerKg: 4500,
    date: DateTime(2025, 6, 9),
  ),
];