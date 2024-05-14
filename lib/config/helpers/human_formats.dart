import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HumanFormats {
  static String number(double number, [int decimals = 1]) {
    return NumberFormat.compactCurrency(
            decimalDigits: decimals, symbol: '', locale: 'en')
        .format(number);
  }

  static String shortDate(DateTime date) {
    initializeDateFormatting('es');
    final format = DateFormat('EEEE, dd/MM/yyyy', 'es');
    return format.format(date);
  }
}
