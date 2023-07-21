import 'package:flutter_bloc/flutter_bloc.dart';

enum AppPage {
  home,
  parking,
  map,
}

class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.map);

  void showHomePage() => emit(AppPage.home);
  void showParkingPage() => emit(AppPage.parking);
  void showMapPage() => emit(AppPage.map);
}
