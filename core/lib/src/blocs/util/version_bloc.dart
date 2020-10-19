import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../../../core.dart';
import '../../providers/version_provider.dart';

class VersionBloc {
  // VersionBloc({this.av, this.os, this.versionProvider}) {
  //   networkState.add(NetworkState.Start);

  //   fetch();
  // }

  // final String av;
  // final BehaviorSubject<NetworkState> networkState =
  //     BehaviorSubject<NetworkState>();

  // final String os;
  // final BehaviorSubject<VersionModel> repoData =
  //     BehaviorSubject<VersionModel>();

  final VersionProvider versionProvider = VersionProvider();

  // void fetch() {
  //   getVersionRepos(os, av).then((data) {
  //     repoData.add(data);
  //     networkState.add(NetworkState.Normal);
  //   }).catchError(print);
  // }

  Future<VersionModel> getVersionRepos(String os, String av) {
    return versionProvider
        .version(os, av)
        .catchError((exception) => {ExceptionHandler.handleError(exception)});
  }

  // void dispose() {
  //   repoData.close();
  // }
}
