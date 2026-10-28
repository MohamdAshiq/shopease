# ShopEase Monorepo

An end-to-end e-commerce solution built with Flutter and Dart, organized as a modular monorepo.

## Project Structure

```text
shop_ease/
├── apps/
│   ├── customer_mobile/   # Flutter mobile application (iOS & Android)
│   └── admin_web/         # Flutter web management dashboard
└── packages/
    └── shopease_core/     # Shared domain models, contracts, and business logic
```

## Workspaces Overview

| Target | Description | Path |
| :--- | :--- | :--- |
| **`customer_mobile`** | Customer-facing mobile shopping application | `apps/customer_mobile` |
| **`admin_web`** | Store administrator dashboard & catalog management | `apps/admin_web` |
| **`shopease_core`** | Shared entities, DTOs, repository interfaces, and utilities | `packages/shopease_core` |

## Getting Started

### 1. Prerequisites
- [Flutter SDK](https://flutter.dev) (3.13+)
- Dart SDK (3.1+)

### 2. Running Customer Mobile App
```bash
cd apps/customer_mobile
flutter pub get
flutter run
```

### 3. Running Admin Web Panel
```bash
cd apps/admin_web
flutter pub get
flutter run -d chrome
```

### 4. Running Tests
```bash
# Core library tests
cd packages/shopease_core && flutter test

# Mobile app tests
cd apps/customer_mobile && flutter test

# Web app tests
cd apps/admin_web && flutter test
```

