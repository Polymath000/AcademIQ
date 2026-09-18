import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayoutCubit extends Cubit<int> {
  MainLayoutCubit() : super(1);

  void changeTab(int index) => emit(index);
}
