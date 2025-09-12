import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final appLogger = Logger(level: kDebugMode ? Level.debug : Level.off);
