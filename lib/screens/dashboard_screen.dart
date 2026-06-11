import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fishing_trip_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../models/fishing_trip.dart';
import '../widgets/charts_widget.dart';
import 'trip_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion Peche Artisanale',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<FishingTripService>(
        builder: (context, service, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStatsGrid(service),
                const SizedBox(height: 24),
                CapturesBarChart(trips: service.trips),
                const SizedBox(height: 16),
                RevenuePieChart(trips: service.trips),
                const SizedBox(height: 24),
                _buildRecentTrips(context, service),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
  return Container(
    width: double.infinity,
    height: 160,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Image.asset(
            'assets/images/peche.jpg',
            fit: BoxFit.cover,
          ),
          // Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.85),
                  AppColors.secondary.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          // Texte
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tableau de bord',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Suivi des prises de peche artisanale',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatsGrid(FishingTripService service) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _StatCard(
          icon: Icons.scale,
          label: 'Total prises',
          value: AppFormatters.weight(service.totalQuantity),
          color: AppColors.primary,
        ),
        _StatCard(
          icon: Icons.payments,
          label: 'Revenu global',
          value: AppFormatters.currency(service.totalRevenue),
          color: AppColors.accent,
        ),
        _StatCard(
          icon: Icons.directions_boat,
          label: 'Nb de sorties',
          value: '${service.totalTrips} sorties',
          color: AppColors.secondary,
        ),
        _StatCard(
          icon: Icons.set_meal,
          label: 'Especes',
          value: '${FishingTripService.availableSpecies.length} especes',
          color: const Color(0xFF7B1FA2),
        ),
      ],
    );
  }

  Widget _buildRecentTrips(BuildContext context, FishingTripService service) {
    final recent = service.trips.reversed.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sorties recentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Aucune sortie enregistree',
                style: TextStyle(color: AppColors.textLight),
              ),
            ),
          )
        else
          ...recent.map(
            (trip) => _RecentTripCard(
              trip: trip,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripDetailScreen(tripId: trip.id),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentTripCard extends StatelessWidget {
  final FishingTrip trip;
  final VoidCallback onTap;

  const _RecentTripCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.set_meal,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.species,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${trip.pirogue} - ${AppFormatters.date(trip.date)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppFormatters.currency(trip.revenue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    fontSize: 13,
                  ),
                ),
                Text(
                  AppFormatters.weight(trip.quantityKg),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}