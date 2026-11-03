# 📱 ShopEase — Customer Mobile Application

[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State-BLoC%20%2F%20Cubit-blueviolet)](https://bloclibrary.dev)
[![Firebase](https://img.shields.io/badge/Backend-Firebase%20Firestore-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)

The customer-facing mobile shopping client for the **ShopEase Monorepo**. Built with Flutter, Clean Architecture, and reactive BLoC state management.

---

## 🌟 Features

* **Authentication**: Google Sign-In & Email/Password registration with automated Firestore profile synchronization.
* **Store Discovery**: Real-time catalog search, category filter chips, and multi-criteria sorting (price, popularity).
* **Product Details**: Variant sizing selector with inventory-bound stock validation.
* **Persistent Cart & Wishlist**: Cloud-synced cart and wishlist scoped to authenticated user accounts.
* **Streamlined Checkout**: Multiple payment options, shipping address selection, and auto-saving of checkout addresses.
* **Order Tracking**: Real-time status updates (`pending` → `processing` → `shipped` → `delivered`) with cancellation workflows.
* **Native Platform Integration**: Adaptive launcher icons, Android 12+ Splash API, and iOS launch screen storyboard.

---

## 📂 Project Architecture

```text
apps/customer_mobile/
├── android/            # Android Gradle configs, adaptive icons, and ProGuard rules
├── ios/                # iOS Runner workspace, storyboards, and AppIcon assets
└── lib/
    ├── app/            # App routing (GoRouter) & theme configuration
    ├── features/       # Feature modules:
    │   ├── auth/       # Login, registration, Google auth cubits & views
    │   ├── cart/       # Cart management & bill calculation
    │   ├── checkout/   # Shipping address selector & order placement
    │   ├── home/       # Hero carousel & category highlights
    │   ├── orders/     # Order tracking & timeline history
    │   ├── profile/    # Customer profile & saved addresses
    │   ├── search/     # Live debounced search & filter toolbar
    │   ├── splash/     # In-app animated branded splash transition
    │   ├── store/      # Catalog browsing & sorting
    │   └── wishlist/   # Saved favorites management
    └── widgets/        # Mobile-specific layout components
```

---

## 🚀 Running the App

### 1. Prerequisites
Ensure you have the Flutter SDK installed and an Android emulator or iOS simulator running.

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

### 4. Run Tests
```bash
flutter test
```

---

## 🔗 Related Workspaces
* [**Main Monorepo Documentation**](../../README.md)
* [**Admin Web Dashboard**](../admin_web/README.md)
* [**ShopEase Core Library**](../../packages/shopease_core/README.md)
