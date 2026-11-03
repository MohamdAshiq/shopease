# 💻 ShopEase — Admin Web Management Portal

[![Platform](https://img.shields.io/badge/Platform-Flutter%20Web-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![State Management](https://img.shields.io/badge/State-BLoC%20%2F%20Cubit-blueviolet)](https://bloclibrary.dev)
[![Charts](https://img.shields.io/badge/Analytics-FL%20Chart-FF6D00)](https://pub.dev/packages/fl_chart)

The executive administration portal for the **ShopEase Monorepo**. Built with Flutter Web, providing real-time store management, inventory control, and customer analytics.

---

## 🌟 Features

* **Executive Dashboard**: Real-time total revenue, order count, active customer count, and low-stock alerts calculated live from Firestore.
* **Visual Analytics**: Interactive sales and order volume performance charts powered by `fl_chart`.
* **Catalog & Inventory Control**: Add, update, stock-adjust, and delete products with immediate real-time sync to customer mobile devices.
* **Order Dispatch & Fulfillment**: Search, filter, inspect line items, and advance order statuses (`pending` → `processing` → `shipped` → `delivered`) with timestamped audit notes.
* **Customer CRM**: Calculate customer Lifetime Value (LTV), total orders placed, and automatically assign customer tiers (Bronze, Silver, Gold).
* **Progressive Web App (PWA)**: Includes manifest configuration, custom brand icons, theme styling, and SPA URL rewrite support for hosting.

---

## 📂 Project Architecture

```text
apps/admin_web/
├── web/                # Web manifest, icons, favicon, and SPA index.html
└── lib/
    ├── app/            # Admin routing (GoRouter) & shell navigation
    ├── features/       # Feature modules:
    │   ├── auth/       # Admin login & Firebase Auth session management
    │   ├── customers/  # Customer data table, LTV calculation & detail drawers
    │   ├── dashboard/  # KPI metric calculation & analytics graphs
    │   ├── orders/     # Orders data table & status management modals
    │   ├── products/   # Inventory data table & add/edit product dialogs
    │   └── settings/   # Store identity, status footer & profile management
    └── main.dart       # Web entry point with error boundary
```

---

## 🚀 Running the Portal

### 1. Prerequisites
Ensure you have the Flutter SDK installed and Google Chrome available.

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run on Chrome
```bash
flutter run -d chrome
```

### 4. Build for Production Web Hosting
```bash
flutter build web --release
```
The compiled output will be generated in `build/web`, ready for deployment to Firebase Hosting or any static host.

### 5. Run Tests
```bash
flutter test
```

---

## 🔗 Related Workspaces
* [**Main Monorepo Documentation**](../../README.md)
* [**Customer Mobile App**](../customer_mobile/README.md)
* [**ShopEase Core Library**](../../packages/shopease_core/README.md)
