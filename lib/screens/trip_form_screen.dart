import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/fishing_trip.dart';
import '../services/fishing_trip_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class TripFormScreen extends StatefulWidget {
  final FishingTrip? trip;

  const TripFormScreen({super.key, this.trip});

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPirogue;
  String? _selectedSpecies;
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool get _isEditing => widget.trip != null;

  // Calcul automatique du revenu
  double get _calculatedRevenue {
    final qty = double.tryParse(_quantityController.text) ?? 0;
    final price = int.tryParse(_priceController.text) ?? 0;
    return qty * price;
  }

  @override
  void initState() {
    super.initState();
    // Si on est en mode édition, on pré-remplit les champs
    if (_isEditing) {
      final trip = widget.trip!;
      _selectedPirogue = trip.pirogue;
      _selectedSpecies = trip.species;
      _quantityController.text = trip.quantityKg.toString();
      _priceController.text = trip.pricePerKg.toString();
      _selectedDate = trip.date;
    }
    // Recalcule le revenu à chaque changement
    _quantityController.addListener(() => setState(() {}));
    _priceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la sortie' : 'Nouvelle sortie'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Pirogue ─────────────────────────────
              _buildLabel('Pirogue'),
              const SizedBox(height: 8),
              _buildPirogueDropdown(),
              const SizedBox(height: 20),

              // ── Espece ──────────────────────────────
              _buildLabel('Espece de poisson'),
              const SizedBox(height: 8),
              _buildSpeciesDropdown(),
              const SizedBox(height: 20),

              // ── Quantite ────────────────────────────
              _buildLabel('Quantite (kg)'),
              const SizedBox(height: 8),
              _buildQuantityField(),
              const SizedBox(height: 20),

              // ── Prix ────────────────────────────────
              _buildLabel('Prix au kg (FCFA)'),
              const SizedBox(height: 8),
              _buildPriceField(),
              const SizedBox(height: 20),

              // ── Date ────────────────────────────────
              _buildLabel('Date de capture'),
              const SizedBox(height: 8),
              _buildDatePicker(context),
              const SizedBox(height: 24),

              // ── Revenu calcule ───────────────────────
              _buildRevenueCard(),
              const SizedBox(height: 32),

              // ── Bouton enregistrer ───────────────────
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Label ────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        fontSize: 14,
      ),
    );
  }

  // ── Dropdown Pirogue ─────────────────────────────────────

  Widget _buildPirogueDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedPirogue,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.directions_boat, color: AppColors.primary),
        hintText: 'Selectionnez une pirogue',
      ),
      items: FishingTripService.availablePirogues
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
      onChanged: (val) => setState(() => _selectedPirogue = val),
      validator: (val) => val == null ? 'Veuillez selectionner une pirogue' : null,
    );
  }

  // ── Dropdown Espece ──────────────────────────────────────

  Widget _buildSpeciesDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSpecies,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.set_meal, color: AppColors.primary),
        hintText: 'Selectionnez une espece',
      ),
      items: FishingTripService.availableSpecies
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: (val) => setState(() => _selectedSpecies = val),
      validator: (val) => val == null ? 'Veuillez selectionner une espece' : null,
    );
  }

  // ── Champ Quantite ───────────────────────────────────────

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.scale, color: AppColors.primary),
        hintText: 'Ex: 45.5',
        suffixText: 'kg',
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Champ obligatoire';
        final qty = double.tryParse(val);
        if (qty == null || qty <= 0) return 'La quantite doit etre superieure a 0';
        return null;
      },
    );
  }

  // ── Champ Prix ───────────────────────────────────────────

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.payments, color: AppColors.primary),
        hintText: 'Ex: 3500',
        suffixText: 'FCFA/kg',
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Champ obligatoire';
        final price = int.tryParse(val);
        if (price == null || price <= 0) return 'Le prix doit etre superieur a 0';
        return null;
      },
    );
  }

  // ── Selecteur de date ────────────────────────────────────

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          locale: const Locale('fr', 'FR'),
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E7FF)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              AppFormatters.date(_selectedDate),
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textDark,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  // ── Carte revenu calcule ─────────────────────────────────

  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Revenu calcule',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 13,
                ),
              ),
              Text(
                'Quantite x Prix au kg',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(
            AppFormatters.currency(_calculatedRevenue),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bouton enregistrer ───────────────────────────────────

  Widget _buildSubmitButton(BuildContext context) {
    final service = context.read<FishingTripService>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _submit(service),
        icon: Icon(_isEditing ? Icons.save : Icons.add),
        label: Text(
          _isEditing ? 'Enregistrer les modifications' : 'Creer la sortie',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // ── Logique de soumission ────────────────────────────────

  void _submit(FishingTripService service) async {
  if (!_formKey.currentState!.validate()) return;

  if (_isEditing) {
    await service.updateTrip(
      widget.trip!.copyWith(
        pirogue: _selectedPirogue,
        species: _selectedSpecies,
        quantityKg: double.parse(_quantityController.text),
        pricePerKg: int.parse(_priceController.text),
        date: _selectedDate,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sortie modifiee avec succes'),
          backgroundColor: AppColors.accent,
        ),
      );
    }
  } else {
    await service.addTrip(
      pirogue: _selectedPirogue!,
      species: _selectedSpecies!,
      quantityKg: double.parse(_quantityController.text),
      pricePerKg: int.parse(_priceController.text),
      date: _selectedDate,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sortie creee avec succes'),
          backgroundColor: AppColors.accent,
        ),
      );
    }
  }

  if (mounted) Navigator.pop(context);
}

}

