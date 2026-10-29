import 'package:flutter_bloc/flutter_bloc.dart';

// State management for bottom navigation active tab
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void setTab(int index) => emit(index);
}
