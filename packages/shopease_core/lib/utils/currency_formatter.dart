// Extension for formatting numbers to INR
extension CurrencyFormatter on num {
  String get inr => '₹${toStringAsFixed(0)}';
}
