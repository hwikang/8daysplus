import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockableWidget extends StatelessWidget {
  const BlockableWidget({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ProcessorBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isProcessingStream,
      initialData: false,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: snapshot.data,
          child: child,
        );
      },
    );
  }
}
