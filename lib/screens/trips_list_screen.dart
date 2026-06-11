import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/fishing_trip_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../models/fishing_trip.dart';
import 'trip_detail_screen.dart';
import 'trip_form_screen.dart';

class TripsListScreen extends StatefulWidget {
  const TripsListScreen({super.key});

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  final _searchController = TextEditingController();
  String _selectedSpecies = '';
  String _selectedPirogue = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des sorties'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TripFormScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle sortie'),
      ),
      body: Consumer<FishingTripService>(
        builder: (context, service, _) {
          final filtered = service.filter(
            species: _selectedSpecies,
            pirogue: _selectedPirogue,
            search: _searchController.text,
          );

          return Column(
            children: [
              _buildFilters(service),
              _buildSummary(filtered),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final trip = filtered[index];
                          return _TripCard(
                            trip: trip,
                            onView: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TripDetailScreen(tripId: trip.id),
                              ),
                            ),
                            onEdit: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TripFormScreen(),
                                ),
                              );
                            },
                            onDelete: () =>
                                _confirmDelete(context, service, trip),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(FishingTripService service) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Rechercher par pirogue ou espece...',
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: _selectedSpecies,
                  hint: 'Toutes especes',
                  items: FishingTripService.availableSpecies,
                  onChanged: (val) =>
                      setState(() => _selectedSpecies = val ?? ''),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  value: _selectedPirogue,
                  hint: 'Toutes pirogues',
                  items: FishingTripService.availablePirogues,
                  onChanged: (val) =>
                      setState(() => _selectedPirogue = val ?? ''),
                ),
              ),
            ],
          ),
          if (_selectedSpecies.isNotEmpty ||
              _selectedPirogue.isNotEmpty ||
              _searchController.text.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() {
                  _selectedSpecies = '';
                  _selectedPirogue = '';
                  _searchController.clear();
                }),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Effacer les filtres'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.danger,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSummary(List<FishingTrip> trips) {
    final totalRevenue = trips.fold(0.0, (s, t) => s + t.revenue);
    final totalQty = trips.fold(0.0, (s, t) => s + t.quantityKg);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Row(
        children: [
          Text(
            '${trips.length} sortie(s)',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          Text(
            AppFormatters.weight(totalQty),
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppFormatters.currency(totalRevenue),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 64, color: AppColors.textLight),
          SizedBox(height: 16),
          Text(
            'Aucune sortie trouvee',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

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

class _TripCard extends StatelessWidget {
  final FishingTrip trip;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TripCard({
    required this.trip,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.directions_boat,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      trip.pirogue,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Text(
                  AppFormatters.date(trip.date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoChip(
                  label: trip.species,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  label: AppFormatters.weight(trip.quantityKg),
                  color: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppFormatters.currency(trip.revenue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.visibility,
                      color: AppColors.primary,
                      onTap: onView,
                      tooltip: 'Voir',
                    ),
                    const SizedBox(width: 6),
                    _ActionButton(
                      icon: Icons.edit,
                      color: AppColors.secondary,
                      onTap: onEdit,
                      tooltip: 'Modifier',
                    ),
                    const SizedBox(width: 6),
                    _ActionButton(
                      icon: Icons.delete,
                      color: AppColors.danger,
                      onTap: onDelete,
                      tooltip: 'Supprimer',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}