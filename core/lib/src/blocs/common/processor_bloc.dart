import 'package:rxdart/rxdart.dart';

class ProcessorBloc {
  ProcessorBloc({bool initial = false}) : super() {
    isProcessingStream.add(initial);
  }

  final BehaviorSubject<bool> isProcessingStream = BehaviorSubject<bool>();

  bool get isProcessing => isProcessingStream.value;

  void start() {
    isProcessingStream.add(true);
  }

  void finish() {
    isProcessingStream.add(false);
  }
}
