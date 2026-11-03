# 📦 ShopEase Core Library

[![Dart](https://img.shields.io/badge/Dart-3.1%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Package](https://img.shields.io/badge/Package-Internal%20Monorepo-blueviolet)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Domain-green)](https://flutter.dev)

The foundational domain and infrastructure package for the **ShopEase Monorepo**. Shared across the Customer Mobile app (`apps/customer_mobile`) and Admin Web dashboard (`apps/admin_web`).

---

## 🏛 Package Organization

```text
packages/shopease_core/
├── assets/                 # Shared brand logos and animations
└── lib/
    ├── constants/          # Static categories, order status enums, asset paths
    ├── models/             # Immutable domain entities (Product, Order, User, Address, Cart)
    ├── repositories/       # Abstract repository interfaces & Cloud Firestore implementations:
    │   ├── auth_repository.dart
    │   ├── firebase_auth_repository.dart
    │   ├── order_repository.dart
    │   ├── firestore_order_repository.dart
    │   ├── product_repository.dart
    │   └── firestore_product_repository.dart
    ├── services/           # Local storage services (Cart, Wishlist, Search history)
    ├── theme/              # Unified design system:
    │   ├── app_colors.dart
    │   ├── app_sizes.dart
    │   ├── app_text_styles.dart
    │   └── app_theme.dart
    ├── utils/              # Currency formatting, date parsing, snackbars, and validators
    └── widgets/            # Reusable UI primitives:
        ├── app_brand_logo.dart
        ├── app_button.dart
        ├── app_empty_state.dart
        ├── app_error_fallback.dart
        ├── app_network_image.dart
        ├── app_search_bar.dart
        ├── app_text_field.dart
        ├── discount_badge.dart
        └── order_status_badge.dart
```

---

## 🛠 Usage within the Monorepo

To consume `shopease_core` in an app workspace, reference it via path in your `pubspec.yaml`:

```yaml
dependencies:
  shopease_core:
    path: ../../packages/shopease_core
```

Then import the single umbrella export:

```dart
import 'package:shopease_core/shopease_core.dart';
```

---

## 🧪 Testing

Run the test suite covering domain entities, models, and utility formatters:

```bash
flutter test
```

---

## 🔗 Related Workspaces
* [**Main Monorepo Documentation**](../../README.md)
* [**Customer Mobile App**](../../apps/customer_mobile/README.md)
* [**Admin Web Dashboard**](../../apps/admin_web/README.md)
