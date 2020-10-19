import '../../core.dart';

enum DiscoveryPageState { DiscoveryMain, DiscoveryList, DiscoverySearch }

class DiscoveryPageBloc {
  DiscoveryPageBloc();

  DiscoveryMainPageModel mainModel = DiscoveryMainPageModel();
}
