import 'package:flutter/cupertino.dart';

// 축소 애니메이션 효과
class ScaleRouter<T> extends PageRouteBuilder<T> {
  ScaleRouter(
      {this.child, this.durationms = 500, this.curve = Curves.fastOutSlowIn})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: durationms),
          transitionsBuilder: (context, a1, a2, child) => ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: a1, curve: curve)),
            child: child,
          ),
        );

  final Widget child;
  final int durationms;
  final Curve curve;
}

// 그라데이션 투명 애니메이션 효과
class FadeRouter<T> extends PageRouteBuilder<T> {
  FadeRouter(
      {this.child, this.durationms = 500, this.curve = Curves.fastOutSlowIn})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => child,
            transitionDuration: Duration(milliseconds: durationms),
            transitionsBuilder: (context, a1, a2, child) => FadeTransition(
                  opacity: Tween<double>(begin: 0.1, end: 1.0)
                      .animate(CurvedAnimation(
                    parent: a1,
                    curve: curve,
                  )),
                  child: child,
                ));

  final Widget child;
  final int durationms;
  final Curve curve;
}

// 회전 애니메이션 효과
class RotateRouter<T> extends PageRouteBuilder<T> {
  RotateRouter(
      {this.child, this.durationms = 500, this.curve = Curves.fastOutSlowIn})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => child,
            transitionDuration: Duration(milliseconds: durationms),
            transitionsBuilder: (context, a1, a2, child) => RotationTransition(
                  turns: Tween<double>(begin: 0.1, end: 1.0)
                      .animate(CurvedAnimation(
                    parent: a1,
                    curve: curve,
                  )),
                  child: child,
                ));

  final Widget child;
  final int durationms;
  final Curve curve;
}

// 오른쪽부터 윈쪽으로
class Right2LeftRouter<T> extends PageRouteBuilder<T> {
  Right2LeftRouter(
      {this.child, this.durationms = 300, this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: durationms),
            pageBuilder: (context, a1, a2) {
              return child;
            },
            transitionsBuilder: (
              context,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationms;
  final Curve curve;
}

// 윈쪽부터 오른쪽으로
class Left2RightRouter<T> extends PageRouteBuilder<T> {
  Left2RightRouter(
      {this.child, this.durationms = 500, this.curve = Curves.fastOutSlowIn})
      : assert(true),
        super(
            transitionDuration: Duration(milliseconds: durationms),
            pageBuilder: (context, a1, a2) {
              return child;
            },
            transitionsBuilder: (
              context,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationms;
  final Curve curve;
  List<int> mapper;
}

// 위로부터 아래로
class Top2BottomRouter<T> extends PageRouteBuilder<T> {
  Top2BottomRouter(
      {this.child,
      this.durationMilliSeconds = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: durationMilliSeconds),
            pageBuilder: (context, a1, a2) {
              return child;
            },
            transitionsBuilder: (
              context,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, -1.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationMilliSeconds;
  final Curve curve;
}

// 아래부터 위로
class Bottom2TopRouter<T> extends PageRouteBuilder<T> {
  Bottom2TopRouter(
      {this.child,
      this.durationMilliSeconds = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: durationMilliSeconds),
            pageBuilder: (context, a1, a2) {
              return child;
            },
            transitionsBuilder: (
              context,
              a1,
              a2,
              child,
            ) {
              return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: child);
            });

  final Widget child;
  final int durationMilliSeconds;
  final Curve curve;
}

// 축소 + 투명 + 회전 애니메이션 효과
class ScaleFadeRotateRouter<T> extends PageRouteBuilder<T> {
  ScaleFadeRotateRouter(
      {this.child,
      this.durationMilliSeconds = 500,
      this.curve = Curves.fastOutSlowIn})
      : super(
            transitionDuration: Duration(milliseconds: durationMilliSeconds),
            pageBuilder: (context, a1, a2) => child, // 페이지
            transitionsBuilder: (
              context,
              a1,
              a2,
              child,
            ) {
              // 애니메이션 구축
              return RotationTransition(
                // 회전 애니메이션
                turns:
                    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: a1,
                  curve: curve,
                )),
                child: ScaleTransition(
                  // 축소 애니메이션
                  scale: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(parent: a1, curve: curve)),
                  child: FadeTransition(
                    opacity: // 투명도 애니메이션
                        Tween<double>(begin: 0.5, end: 1.0)
                            .animate(CurvedAnimation(parent: a1, curve: curve)),
                    child: child,
                  ),
                ),
              );
            });

  final Widget child;
  final int durationMilliSeconds;
  final Curve curve;
}

// 무효과
class NoAnimRouter<T> extends PageRouteBuilder<T> {
  NoAnimRouter(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: const Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);

  final Widget page;
}
