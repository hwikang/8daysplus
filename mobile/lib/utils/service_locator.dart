import 'package:get_it/get_it.dart';

import 'navbar.dart';

GetIt locator = GetIt();
void setupLocator() {
  locator.registerSingleton<NavbarIndex>(NavbarIndex());
}
