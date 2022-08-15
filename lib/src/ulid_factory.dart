import 'dart:math';
import 'dart:typed_data';

import 'crockford.dart';
import 'time.dart';

class ULIDFactory {
  const ULIDFactory._(this.random);

  factory ULIDFactory([Random? random]) => ULIDFactory._(random ?? Random());

  final Random random;

  String randomULID([int? timestamp]) {
    final time = timestamp ?? currentTimestamp();
    requireTimestamp(time);
    final buffer = Uint8List(26);
    const max8bit = 4294967295;
    buffer.write(time, 10, 0);
    buffer.write(random.nextInt(max8bit), 8, 10);
    buffer.write(random.nextInt(max8bit), 8, 18);
    return String.fromCharCodes(buffer);
  }
}
