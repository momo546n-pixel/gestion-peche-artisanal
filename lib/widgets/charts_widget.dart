import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/fishing_trip.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

// ── Graphique barres : captures par espece ───────────────

class CapturesBarChart extends StatelessWidget {
  final List<FishingTrip> trips;

  const CapturesBarChart({super.key, required this.trips});

  Map<String, double> get _dataBySpecies {
    final map = <String, double>{};
    for (final trip in trips) {
      map[trip.species] = (map[trip.species] ?? 0) + trip.quantityKg;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final data = _dataBySpecies;
    if (data.isEmpty) return const SizedBox.shrink();

    final species = data.keys.toList();
    final maxY = data.values.reduce((a, b) => a > b ? a : b) * 1.2;

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      const Color(0xFF7B1FA2),
      const Color(0xFFE65100),
      const Color(0xFF00838F),
    ];

    return Container(
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
            'Captures par espece (kg)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} kg',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= species.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            species[index],
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: species.asMap().entries.map((entry) {
                  final index = entry.key;
                  final sp = entry.value;
                  final color = colors[index % colors.length];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data[sp]!,
                        color: color,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Graphique camembert : revenus par espece ─────────────

class RevenuePieChart extends StatefulWidget {
  final List<FishingTrip> trips;

  const RevenuePieChart({super.key, required this.trips});

  @override
  State<RevenuePieChart> createState() => _RevenuePieChartState();
}

class _RevenuePieChartState extends State<RevenuePieChart> {
  int _touchedIndex = -1;

  Map<String, double> get _revenueBySpecies {
    final map = <String, double>{};
    for (final trip in widget.trips) {
      map[trip.species] = (map[trip.species] ?? 0) + trip.revenue;
    }
    return map;
  }

  final List<Color> _colors = const [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    Color(0xFF7B1FA2),
    Color(0xFFE65100),
    Color(0xFF00838F),
  ];

  @override
  Widget build(BuildContext context) {
    final data = _revenueBySpecies;
    if (data.isEmpty) return const SizedBox.shrink();

    final species = data.keys.toList();
    final total = data.values.reduce((a, b) => a + b);

    return Container(
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
            'Revenus par espece',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Camembert
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = response
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: species.asMap().entries.map((entry) {
                      final index = entry.key;
                      final sp = entry.value;
                      final isTouched = index == _touchedIndex;
                      final color = _colors[index % _colors.length];
                      final pct = (data[sp]! / total * 100);

                      return PieChartSectionData(
                        value: data[sp],
                        color: color,
                        radius: isTouched ? 65 : 55,
                        title: '${pct.toStringAsFixed(0)}%',
                        titleStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 35,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Legende
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: species.asMap().entries.map((entry) {
                    final index = entry.key;
                    final sp = entry.value;
                    final color = _colors[index % _colors.length];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sp,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  AppFormatters.currency(data[sp]!),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}