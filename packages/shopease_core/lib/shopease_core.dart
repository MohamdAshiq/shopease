// Core packages
export 'package:equatable/equatable.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:go_router/go_router.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:iconsax_plus/iconsax_plus.dart';
export 'package:lottie/lottie.dart';
export 'package:shared_preferences/shared_preferences.dart';

// Firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart' hide sum;
export 'package:firebase_storage/firebase_storage.dart';

export 'package:skeletonizer/skeletonizer.dart';

// Constants
export 'constants/app_assets.dart';
export 'constants/app_categories.dart';
export 'constants/order_status.dart';

// Models
export 'models/cart_item_model.dart';
export 'models/customer_address_model.dart';
export 'models/order_item_model.dart';
export 'models/order_model.dart';
export 'models/payment_method_model.dart';
export 'models/product_model.dart';
export 'models/user_model.dart';

// Repositories
export 'repositories/auth_repository.dart';
export 'repositories/firebase_auth_repository.dart';
export 'repositories/product_repository.dart';
export 'repositories/firestore_product_repository.dart';

// Services
export 'services/cart_storage_service.dart';
export 'services/search_history_service.dart';
export 'services/wishlist_storage_service.dart';

// Theme
export 'theme/app_colors.dart';
export 'theme/app_sizes.dart';
export 'theme/app_text_styles.dart';
export 'theme/app_theme.dart';

// Utils
export 'utils/app_snackbar.dart';
export 'utils/app_validators.dart';
export 'utils/currency_formatter.dart';
export 'utils/date_formatter.dart';
export 'utils/string_extensions.dart';

// Shared Widgets
export 'widgets/app_brand_logo.dart';
export 'widgets/app_button.dart';
export 'widgets/app_circle_button.dart';
export 'widgets/app_empty_state.dart';
export 'widgets/app_network_image.dart';
export 'widgets/app_search_bar.dart';
export 'widgets/app_text_field.dart';
export 'widgets/discount_badge.dart';
export 'widgets/responsive_layout.dart';
export 'widgets/section_card_header.dart';
