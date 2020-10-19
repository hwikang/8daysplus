abstract class NavbarState {}

class ShowMain extends NavbarState {
  final int itemIndex = 0;
  final String title = 'Main';
}

class ShowSearch extends NavbarState {
  final int itemIndex = 1;
  final String title = 'Search';
}

class ShowMy extends NavbarState {
  final int itemIndex = 2;
  final String title = 'My';
}

class ShowMore extends NavbarState {
  final int itemIndex = 3;
  final String title = 'More';
}
