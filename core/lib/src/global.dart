import 'package:logger/logger.dart';

import 'utils/simple_log_printer.dart';

Logger getLoggerNamed(String name) {
  return Logger(printer: SimpleLogPrinter(name));
}

Logger getLogger(Object object) {
  return getLoggerNamed(object.runtimeType.toString());
}

Logger logger = Logger();
