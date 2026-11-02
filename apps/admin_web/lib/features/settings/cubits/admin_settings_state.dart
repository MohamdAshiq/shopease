import 'package:shopease_core/shopease_core.dart';

// State managing admin store settings
class AdminSettingsState extends Equatable {
  const AdminSettingsState({
    this.storeName = 'ShopEase Store',
    this.supportEmail = 'support@shopease.com',
    this.phone = '+91 98 7654 3210',
    this.currency = 'INR (₹)',
    this.timezone = '(GMT+05:30) Asia/Kolkata (IST)',
    this.isSaving = false,
  });

  final String storeName;
  final String supportEmail;
  final String phone;
  final String currency;
  final String timezone;
  final bool isSaving;

  AdminSettingsState copyWith({
    String? storeName,
    String? supportEmail,
    String? phone,
    String? currency,
    String? timezone,
    bool? isSaving,
  }) {
    return AdminSettingsState(
      storeName: storeName ?? this.storeName,
      supportEmail: supportEmail ?? this.supportEmail,
      phone: phone ?? this.phone,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    storeName,
    supportEmail,
    phone,
    currency,
    timezone,
    isSaving,
  ];
}
