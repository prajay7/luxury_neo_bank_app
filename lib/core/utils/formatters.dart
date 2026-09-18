/// Utility methods for formatting financial numbers without external dependencies.
class ObsidianFormatters {
  ObsidianFormatters._();

  /// Formats currency with commas and 2 decimals: e.g. 248560.8 -> "$248,560.80"
  static String currency(double amount, {bool showSign = false}) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    final parts = absAmount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    final length = integerPart.length;
    for (int i = 0; i < length; i++) {
      if (i > 0 && (length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    final formatted = '\$${buffer.toString()}.$decimalPart';
    if (isNegative) return '-$formatted';
    if (showSign && amount > 0) return '+$formatted';
    return formatted;
  }

  /// Formats compact numbers: e.g. 186420 -> "$186.4K"
  static String compactCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    return currency(amount);
  }

  /// Formats percentage: e.g. 5.45 -> "+5.45%"
  static String percentage(double pct) {
    final prefix = pct >= 0 ? '+' : '';
    return '$prefix${pct.toStringAsFixed(2)}%';
  }
}
