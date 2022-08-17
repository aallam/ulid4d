import 'dart:math';
import 'dart:typed_data';

import 'constants.dart';
import 'crockford.dart';
import 'time.dart';
import 'ulid.dart';

class ULIDFactory {
  const ULIDFactory._(this.random);

  factory ULIDFactory([Random? random]) => ULIDFactory._(random ?? Random());

  final Random random;

  /// Generate a ULID String.
  String randomULID([int? timestamp]) {
    timestamp = timestamp ?? currentTimestamp();
    requireTimestamp(timestamp);
    final buffer = Uint8List(26);
    buffer.write(timestamp, 10, 0);
    buffer.write(random.nextInt(max32bit), 8, 10);
    buffer.write(random.nextInt(max32bit), 8, 18);
    return String.fromCharCodes(buffer);
  }

  /// Generate a [ULID].
  ULID nextULID([int? timestamp]) {
    timestamp = timestamp ?? currentTimestamp();
    requireTimestamp(timestamp);
    var mostSignificantBits = random.nextInt(max32bit);
    final leastSignificantBits = random.nextInt(max32bit);
    mostSignificantBits = mostSignificantBits & mask16Bits; // random 16 bits
    mostSignificantBits = mostSignificantBits |
        (timestamp << 16); // timestamp (32+16) + 16 random
    return ULID(mostSignificantBits, leastSignificantBits);
  }
}
