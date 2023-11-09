import 'package:flutter_bloc/flutter_bloc.dart';

enum AppPage {
  map,
  parking,
}

class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.map);

  void showParkingPage() => emit(AppPage.parking);
  void showMapPage() => emit(AppPage.map);
}
