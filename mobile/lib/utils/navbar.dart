import 'package:rxdart/rxdart.dart';

NavbarIndex navbarIndexService = NavbarIndex();

class NavbarIndex {
  final BehaviorSubject<int> _navbarIndex = BehaviorSubject<int>.seeded(0);

  // Observable<dynamic> get stream$ => _navbarIndex.stream;

  int get current => _navbarIndex.value;

  void setCurrent(int index) {
    _navbarIndex.add(index);
  }
}
