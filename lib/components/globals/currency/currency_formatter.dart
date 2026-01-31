import 'package:intl/intl.dart';

String formatRupiah(num value, {bool withSymbol = true}) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: withSymbol ? 'Rp' : '',
    decimalDigits: 0,
  );
  return formatter.format(value);
}
