# 🛍️ ShopEase — Multiplatform E-Commerce Ecosystem

[![Flutter Version](https://img.shields.io/badge/Flutter-3.13%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.1%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20BLoC%2FCubit-blueviolet)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An enterprise-grade, end-to-end e-commerce solution architected as a modular Flutter monorepo. **ShopEase** comprises a high-performance customer mobile application (iOS & Android), an executive web administration dashboard, and a shared core package managing domain entities, repositories, and unified design tokens.

---

## 📑 Table of Contents
1. [Architectural Overview](#-architectural-overview)
2. [Project Monorepo Structure](#-project-monorepo-structure)
3. [Visual Walkthrough & Gallery](#-visual-walkthrough--gallery)
   * [Customer Mobile Application](#customer-mobile-application-screens)
   * [Admin Web Management Dashboard](#admin-web-dashboard-screens)
4. [Key Features](#-key-features)
5. [Tech Stack & Dependencies](#-tech-stack--dependencies)
6. [Getting Started & Local Setup](#-getting-started--local-setup)
7. [Cloud Firestore & Security Rules](#-cloud-firestore--security-rules)
8. [Testing & Quality Assurance](#-testing--quality-assurance)

---

## 🏛 Architectural Overview

ShopEase follows **Clean Architecture** and the **BLoC / Cubit** design pattern with strict layer decoupling:

```mermaid
flowchart TD
    subgraph UI ["Presentation Layer"]
        A[Flutter Screens & Widgets] -->|Events / Actions| B[Feature Cubits]
    end

    subgraph Domain ["Domain & State Layer"]
        B -->|Emits State| A
        B -->|Invokes Methods| C[Repository Interfaces]
    end

    subgraph Data ["Data & Network Layer"]
        C -->|Implementation| D[Firestore Repositories]
        D -->|Queries / Streams| E[(Cloud Firestore)]
        D -->|Tokens / Sessions| F[(Firebase Authentication)]
    end
```

- **Separation of Concerns**: Presentation UI never communicates directly with Firebase SDKs; all business logic is mediated through reactive Cubits and Repository interfaces.
- **Single Source of Truth**: Shared domain models (`ProductModel`, `OrderModel`, `UserModel`, `CustomerAddressModel`) are maintained within `packages/shopease_core` and consumed identically by both mobile and web clients.
- **Reactive Cloud Sync**: Shopping cart, order tracking, and live catalog changes leverage Firestore snapshot streams for real-time synchronization.

---

## 📂 Project Monorepo Structure

```text
shop_ease/
├── apps/
│   ├── customer_mobile/             # Customer-facing shopping app (iOS & Android)
│   │   ├── android/                 # Android project with adaptive icons & splash configs
│   │   ├── ios/                     # iOS Runner workspace with AppIcon sets
│   │   └── lib/
│   │       ├── app/                 # App routing (GoRouter) & theme bindings
│   │       └── features/            # Feature modules (auth, home, store, cart, checkout, orders, profile)
│   │
│   └── admin_web/                   # Executive store administration portal
│       ├── web/                     # Web manifest, icons, and SPA index.html
│       └── lib/
│           ├── app/                 # Admin navigation & responsive routing
│           └── features/            # Admin features (dashboard, products, orders, customers, settings)
│
├── packages/
│   └── shopease_core/               # Shared domain package
│       ├── assets/                  # Shared brand assets & logos
│       └── lib/
│           ├── constants/           # Order status enums, category definitions, assets
│           ├── models/              # Product, Order, User, Address immutable entities
│           ├── repositories/        # Cloud Firestore & Firebase Auth implementations
│           ├── theme/               # Colors, typography, spacing tokens
│           └── widgets/             # Reusable UI primitives (Buttons, Badges, EmptyStates)
│
├── admin-screenshots/               # Screen captures of the Admin Web management console
├── app-screenshots/                 # Screen captures of the Customer Mobile application
├── firebase.json                    # Single-Page Application (SPA) hosting & rules configuration
└── firestore.rules                  # Production Cloud Firestore Security Rules
```

---

## 📸 Visual Walkthrough & Gallery

### Customer Mobile Application Screens

#### 1. Onboarding & Authentication
<table>
  <tr>
    <td align="center"><b>Login Screen</b></td>
    <td align="center"><b>Registration Screen</b></td>
  </tr>
  <tr>
    <td><img src="app-screenshots/login-screen.jpeg" width="260" alt="Customer Login Screen" /></td>
    <td><img src="app-screenshots/register-screen.jpeg" width="260" alt="Customer Register Screen" /></td>
  </tr>
</table>

#### 2. Discovery & Catalog Browsing
<table>
  <tr>
    <td align="center"><b>Home Screen</b></td>
    <td align="center"><b>Store / Catalog Screen</b></td>
    <td align="center"><b>Sorting Options</b></td>
    <td align="center"><b>Empty Search State</b></td>
  </tr>
  <tr>
    <td><img src="app-screenshots/home-screen.jpeg" width="220" alt="Home Screen" /></td>
    <td><img src="app-screenshots/store-screen.jpeg" width="220" alt="Store Catalog" /></td>
    <td><img src="app-screenshots/sort-options.jpeg" width="220" alt="Catalog Sorting" /></td>
    <td><img src="app-screenshots/search-not-found.jpeg" width="220" alt="Search Empty State" /></td>
  </tr>
</table>

#### 3. Product Details & Wishlist
<table>
  <tr>
    <td align="center"><b>Product Size Selector</b></td>
    <td align="center"><b>Saved Wishlist</b></td>
    <td align="center"><b>Empty Wishlist View</b></td>
  </tr>
  <tr>
    <td><img src="app-screenshots/size-selector-view.jpeg" width="220" alt="Product Size Selector" /></td>
    <td><img src="app-screenshots/wishlist-screen.jpeg" width="220" alt="Wishlist Screen" /></td>
    <td><img src="app-screenshots/empty-wishlsit-view.jpeg" width="220" alt="Empty Wishlist" /></td>
  </tr>
</table>

#### 4. Cart, Checkout & Fulfillment
<table>
  <tr>
    <td align="center"><b>Shopping Cart</b></td>
    <td align="center"><b>Empty Cart State</b></td>
    <td align="center"><b>Checkout Screen</b></td>
    <td align="center"><b>Order Success Screen</b></td>
  </tr>
  <tr>
    <td><img src="app-screenshots/my-cart-screen.jpeg" width="220" alt="My Cart" /></td>
    <td><img src="app-screenshots/empty-cart-view.jpeg" width="220" alt="Empty Cart" /></td>
    <td><img src="app-screenshots/checkout-screen.jpeg" width="220" alt="Checkout Screen" /></td>
    <td><img src="app-screenshots/order-success-screen.jpeg" width="220" alt="Order Success" /></td>
  </tr>
</table>

#### 5. Order Tracking & Customer Profile
<table>
  <tr>
    <td align="center"><b>My Orders Screen</b></td>
    <td align="center"><b>Order Details & Tracking</b></td>
    <td align="center"><b>Customer Profile Screen</b></td>
    <td align="center"><b>Saved Addresses</b></td>
  </tr>
  <tr>
    <td><img src="app-screenshots/my-orders-screen.jpeg" width="220" alt="Orders List" /></td>
    <td><img src="app-screenshots/order-details-screen.jpeg" width="220" alt="Order Details" /></td>
    <td><img src="app-screenshots/profile-screen.jpeg" width="220" alt="Profile Screen" /></td>
    <td><img src="app-screenshots/saved-addresses.jpeg" width="220" alt="Saved Addresses" /></td>
  </tr>
</table>

---

### Admin Web Dashboard Screens

#### 1. Authentication & Analytics Overview
<table>
  <tr>
    <td align="center"><b>Admin Console Login</b></td>
    <td align="center"><b>Executive Dashboard (Top KPIs)</b></td>
  </tr>
  <tr>
    <td><img src="admin-screenshots/admin-login.png" width="460" alt="Admin Login" /></td>
    <td><img src="admin-screenshots/dashboard-top-view.png" width="460" alt="Dashboard Top View" /></td>
  </tr>
  <tr>
    <td align="center"><b>Dashboard Performance Analytics</b></td>
    <td align="center"><b>Dashboard (Empty State)</b></td>
  </tr>
  <tr>
    <td><img src="admin-screenshots/dashboard-bottom-view.png" width="460" alt="Dashboard Bottom View" /></td>
    <td><img src="admin-screenshots/dashboard-empty.png" width="460" alt="Dashboard Empty State" /></td>
  </tr>
</table>

#### 2. Inventory & Product Management
<table>
  <tr>
    <td align="center"><b>Products Inventory Table</b></td>
    <td align="center"><b>Products (Empty State)</b></td>
  </tr>
  <tr>
    <td><img src="admin-screenshots/products-view.png" width="460" alt="Products Table" /></td>
    <td><img src="admin-screenshots/products-empty.png" width="460" alt="Products Empty" /></td>
  </tr>
</table>

#### 3. Orders Management & Tracking
<table>
  <tr>
    <td align="center"><b>Order Dispatch Management Table</b></td>
    <td align="center"><b>Order Details & History Modal</b></td>
  </tr>
  <tr>
    <td><img src="admin-screenshots/orders-view.png" width="460" alt="Orders Table" /></td>
    <td><img src="admin-screenshots/order-details-view.png" width="460" alt="Order Details Modal" /></td>
  </tr>
</table>

#### 4. Customer Intelligence & Settings
<table>
  <tr>
    <td align="center"><b>Customer Accounts & LTV Tiers</b></td>
    <td align="center"><b>Store Identity & Settings</b></td>
  </tr>
  <tr>
    <td><img src="admin-screenshots/customers-view.png" width="460" alt="Customers Table" /></td>
    <td><img src="admin-screenshots/settings-view.png" width="460" alt="Settings Screen" /></td>
  </tr>
</table>

---

## ⚡ Key Features

### 📱 Customer Mobile App (`apps/customer_mobile`)
- **Seamless Authentication**: Google Sign-In and Email/Password registration with Firestore profile initialization.
- **Dynamic Catalog**: Category filtering, real-time search, multi-criteria sorting (price, popularity), and stock badge alerts.
- **Product Variants**: Size selector with inventory-bound stock checks.
- **Cart & Wishlist Persistence**: User-scoped shopping cart and wishlist synced to Cloud Firestore.
- **One-Click Checkout**: Direct delivery address selection, auto-saving of checkout addresses to user profiles, and order placement.
- **Order Lifecycle Tracking**: Live status updates (`pending` → `processing` → `shipped` → `delivered`) with audit history.
- **Native Brand Integration**: Android adaptive launcher icons, Android 12+ Splash API, iOS `LaunchScreen.storyboard`, and animated in-app transitions.

### 💻 Admin Web Management Portal (`apps/admin_web`)
- **Executive KPI Strip**: Real-time total revenue, order count, active customer count, and low-stock alerts computed live from Firestore.
- **Catalog Management**: Add, edit, or delete inventory with instant client reflection.
- **Order Dispatch Workflow**: View items, shipping destinations, and update order status with status note histories.
- **Customer CRM**: Calculate customer Lifetime Value (LTV), order frequency, and categorize customers into tiers (Bronze, Silver, Gold).
- **Progressive Web App (PWA)**: Manifest, custom favicon, and single-page routing rewrites configured.

### 🛡️ Shared Core Package (`packages/shopease_core`)
- **Normalized Data Architecture**: Type-safe data serialization with `Equatable` immutability.
- **Production Error Boundaries**: Shared `AppErrorFallback` widget replacing unhandled crash views.
- **Unified Design Tokens**: Consistent color palettes, responsive typography, and spacing constants.

---

## 🛠 Tech Stack & Dependencies

| Layer | Technologies |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (v3.13+) & [Dart](https://dart.dev) (v3.1+) |
| **State Management** | [flutter_bloc](https://pub.dev/packages/flutter_bloc) & [equatable](https://pub.dev/packages/equatable) |
| **Routing** | [go_router](https://pub.dev/packages/go_router) |
| **Backend & Cloud** | [Cloud Firestore](https://pub.dev/packages/cloud_firestore), [Firebase Auth](https://pub.dev/packages/firebase_auth), [Firebase Storage](https://pub.dev/packages/firebase_storage) |
| **UI Components** | [google_fonts](https://pub.dev/packages/google_fonts), [iconsax_plus](https://pub.dev/packages/iconsax_plus), [lottie](https://pub.dev/packages/lottie), [carousel_slider](https://pub.dev/packages/carousel_slider) |
| **Local Storage** | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| **Data Analytics** | [fl_chart](https://pub.dev/packages/fl_chart) (Web Dashboard) |

---

## 🚀 Getting Started & Local Setup

### 1. Prerequisites
- **Flutter SDK**: `^3.13.7` or later installed ([flutter.dev/get-started](https://docs.flutter.dev/get-started/install)).
- **Android Studio / Xcode**: Configured for mobile builds.
- **Firebase CLI**: Installed and authenticated (`npm install -g firebase-tools` && `firebase login`).

### 2. Clone the Repository
```bash
git clone https://github.com/MohamdAshiq/shop_ease.git
cd shop_ease
```

### 3. Bootstrap Dependencies
```bash
# Core package
cd packages/shopease_core && flutter pub get

# Customer mobile app
cd ../../apps/customer_mobile && flutter pub get

# Admin web portal
cd ../admin_web && flutter pub get

cd ../..
```

### 4. Running the Applications

#### Run the Mobile Application (Android / iOS):
```bash
cd apps/customer_mobile
flutter run
```

#### Run the Admin Web Dashboard:
```bash
cd apps/admin_web
flutter run -d chrome
```

---

## 🔒 Cloud Firestore & Security Rules

The workspace includes production-grade Firestore Security Rules located at [`firestore.rules`](firestore.rules).

### Access Policies Enforced:
- **`products`**: Public read access for guest catalog browsing. Write/update/delete restricted to administrators.
- **`users`**: Individual user documents can only be accessed or modified by their verified owner (`request.auth.uid == userId`) or an administrator. Role self-escalation to `admin` is blocked.
- **`orders`**: Customers can read their own order history and create orders with positive totals. Order status transitions are restricted to administrators (except customer cancellation prior to dispatch).

### Deploying Rules via Firebase CLI:
```bash
firebase deploy --only firestore:rules
```

---

## 🧪 Testing & Quality Assurance

Run the test suite across all workspace targets:

```bash
# Run shared domain & repository tests
cd packages/shopease_core && flutter test

# Run customer mobile widget & cubit tests
cd ../../apps/customer_mobile && flutter test

# Run admin web unit tests
cd ../admin_web && flutter test
```

---

## 📄 License
This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
