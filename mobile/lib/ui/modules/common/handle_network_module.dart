import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/handle_network_error.dart';

class HandleNetworkModule extends StatelessWidget {
  const HandleNetworkModule(
      {this.networkState,
      this.child,
      this.retry,
      this.preventStartState = false});

  final Widget child;
  final BehaviorSubject<NetworkState> networkState;
  final bool preventStartState;
  final Function retry;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NetworkState>(
        stream: networkState,
        initialData: NetworkState.Start,
        builder: (context, stateSnapshot) {
          print('stateSnapshot ${stateSnapshot.data} $preventStartState');
          return HandleNetworkError.handleNetwork(
              preventStartState: preventStartState,
              state: stateSnapshot.data,
              retry: () {
                networkState.add(NetworkState.Start);
                return retry();
              },
              context: context,
              child: child);
        });
  }
}
