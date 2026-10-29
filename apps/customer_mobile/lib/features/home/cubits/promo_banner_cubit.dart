import 'package:flutter_bloc/flutter_bloc.dart';

// State management for promo carousel active page index
class PromoBannerCubit extends Cubit<int> {
  PromoBannerCubit() : super(0);

  void setPage(int index) => emit(index);
}
