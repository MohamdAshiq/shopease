// Extension for formatting numbers to INR
extension CurrencyFormatter on num {
  // Format with no decimal places
  String get inr => '₹${toStringAsFixed(0)}';

  // Format with 2 decimal places
  String get inr2 => '₹${toStringAsFixed(2)}';
}

extension NullableCurrencyFormatter on num? {
  // Format with no decimal places, or default to ₹0
  String get inr => this == null ? '₹0' : this!.inr;

  // Format with 2 decimal places, or default to ₹0.00
  String get inr2 => this == null ? '₹0.00' : this!.inr2;
}
