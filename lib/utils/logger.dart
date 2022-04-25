import 'package:simple_logger/simple_logger.dart';
export 'package:logger/logger.dart';
final SimpleLogger logger = SimpleLogger()
  ..mode = LoggerMode.print
  ..setLevel(
    Level.FINEST,
    includeCallerInfo: true,
  );

