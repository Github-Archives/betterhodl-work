import 'package:intl/intl.dart';

final NumberFormat currencyFormatter = NumberFormat.simpleCurrency();
final NumberFormat lowPriceCurrencyFormatter =
    NumberFormat.simpleCurrency(decimalDigits: 6);
final NumberFormat compactCurrencyFormatter =
    NumberFormat.compactSimpleCurrency();
final NumberFormat percentFormatter =
    NumberFormat.decimalPercentPattern(decimalDigits: 2);

String formatCurrency(double value) {
  return value < 1.0
      ? lowPriceCurrencyFormatter.format(value)
      : currencyFormatter.format(value);
}

String formatCompactCurrency(double value) {
  return compactCurrencyFormatter.format(value);
}

String formatPercent(double value) {
  return percentFormatter.format(value / 100.00);
}

String formatDate(DateTime dateTime) {
  return DateFormat.yMMMd().format(dateTime);
}
