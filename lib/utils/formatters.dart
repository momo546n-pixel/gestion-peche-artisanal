import 'package:intl/intl.dart';

class AppFormatters {
  /// Ex: 157 500 FCFA
  static String currency(double amount) {
    return '${NumberFormat('#,##0', 'fr_FR').format(amount)} FCFA';
  }

  /// Ex: 45,5 kg
  static String weight(double kg) {
    return '${NumberFormat('#,##0.#', 'fr_FR').format(kg)} kg';
  }

  /// Ex: 07 juin 2025
  static String date(DateTime d) {
    return DateFormat('dd MMM yyyy', 'fr_FR').format(d);
  }
}