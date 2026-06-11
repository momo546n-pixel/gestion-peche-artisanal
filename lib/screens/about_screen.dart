import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A propos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header projet ──────────────────────────
            Container(
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
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.directions_boat,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gestion Peche Artisanale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Infos projet ───────────────────────────
            _buildSection(
              title: 'Projet academique',
              items: const [
                _InfoItem(
                  icon: Icons.school,
                  label: 'Etablissement',
                  value: 'ESMT - Dakar',
                ),
                _InfoItem(
                  icon: Icons.person,
                  label: 'Etudiant',
                  value: 'Mouhamed Rassoul NIANG',
                ),
                _InfoItem(
                  icon: Icons.flag,
                  label: 'ODD',
                  value: 'ODD 14 - Vie Aquatique',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Fonctionnalites ────────────────────────
            _buildSection(
              title: 'Fonctionnalites',
              items: const [
                _InfoItem(
                  icon: Icons.add_circle,
                  label: 'Creation',
                  value: 'Enregistrer des sorties de peche',
                ),
                _InfoItem(
                  icon: Icons.calculate,
                  label: 'Calcul automatique',
                  value: 'Revenu = Quantite x Prix au kg',
                ),
                _InfoItem(
                  icon: Icons.filter_list,
                  label: 'Filtres',
                  value: 'Par espece, pirogue et date',
                ),
                _InfoItem(
                  icon: Icons.bar_chart,
                  label: 'Statistiques',
                  value: 'Graphiques et tableau de bord',
                ),
                _InfoItem(
                  icon: Icons.save,
                  label: 'Persistance',
                  value: 'Donnees sauvegardees localement',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Especes ────────────────────────────────
            _buildSection(
              title: 'Especes couvertes',
              items: const [
                _InfoItem(
                  icon: Icons.set_meal,
                  label: 'Thiof',
                  value: 'Merou blanc - espece premium',
                ),
                _InfoItem(
                  icon: Icons.set_meal,
                  label: 'Yaboy',
                  value: 'Pageot - tres apprecie',
                ),
                _InfoItem(
                  icon: Icons.set_meal,
                  label: 'Sardinelle',
                  value: 'Peche en grande quantite',
                ),
                _InfoItem(
                  icon: Icons.set_meal,
                  label: 'Capitaine',
                  value: 'Poisson de haute valeur',
                ),
                _InfoItem(
                  icon: Icons.set_meal,
                  label: 'Dorade',
                  value: 'Populaire sur les marches',
                ),
                _InfoItem(
                  icon: Icons.set_meal,
                  label: 'Maquereau',
                  value: 'Peche saisonniere',
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_InfoItem> items,
  }) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textLight,
                            ),
                          ),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}