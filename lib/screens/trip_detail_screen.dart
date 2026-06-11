import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fishing_trip.dart';
import '../services/fishing_trip_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'trip_form_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<FishingTripService>();
    final trip = service.getById(tripId);

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail de la sortie')),
        body: const Center(
          child: Text('Sortie introuvable'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail de la sortie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TripFormScreen(trip: trip),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────
            _buildHeader(trip),
            const SizedBox(height: 20),

            // ── Informations ─────────────────────────
            _buildInfoCard(trip),
            const SizedBox(height: 16),

            // ── Revenu ───────────────────────────────
            _buildRevenueCard(trip),
            const SizedBox(height: 32),

            // ── Actions ──────────────────────────────
            _buildActions(context, service, trip),
          ],
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────

  Widget _buildHeader(FishingTrip trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_boat,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                trip.pirogue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HeaderChip(label: trip.species),
              const SizedBox(width: 8),
              _HeaderChip(label: AppFormatters.date(trip.date)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Carte informations ────────────────────────────────────

  Widget _buildInfoCard(FishingTrip trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.directions_boat,
            label: 'Pirogue',
            value: trip.pirogue,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.set_meal,
            label: 'Espece',
            value: trip.species,
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: AppFormatters.date(trip.date),
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.scale,
            label: 'Quantite',
            value: AppFormatters.weight(trip.quantityKg),
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.payments,
            label: 'Prix au kg',
            value: AppFormatters.currency(trip.pricePerKg.toDouble()),
          ),
        ],
      ),
    );
  }

  // ── Carte revenu ─────────────────────────────────────────

  Widget _buildRevenueCard(FishingTrip trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Revenu genere',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${AppFormatters.weight(trip.quantityKg)} x ${AppFormatters.currency(trip.pricePerKg.toDouble())}',
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(
            AppFormatters.currency(trip.revenue),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  // ── Boutons actions ──────────────────────────────────────

  Widget _buildActions(
    BuildContext context,
    FishingTripService service,
    FishingTrip trip,
  ) {
    return Row(
      children: [
        // Bouton Modifier
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TripFormScreen(trip: trip),
              ),
            ),
            icon: const Icon(Icons.edit),
            label: const Text('Modifier'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Bouton Supprimer
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmDelete(context, service, trip),
            icon: const Icon(Icons.delete),
            label: const Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Confirmation suppression ─────────────────────────────

  void _confirmDelete(
    BuildContext context,
    FishingTripService service,
    FishingTrip trip,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la sortie'),
        content: Text(
          'Voulez-vous supprimer la sortie de ${trip.pirogue} (${trip.species}) ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              service.deleteTrip(trip.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sortie supprimee'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

// ── Chip header ──────────────────────────────────────────

class _HeaderChip extends StatelessWidget {
  final String label;

  const _HeaderChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Ligne information ────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}