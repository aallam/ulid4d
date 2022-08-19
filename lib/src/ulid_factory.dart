import 'dart:math';
import 'dart:typed_data';

import 'crockford.dart';
import 'ulid.dart';
import 'utils.dart';

/// ULID factory builder.
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

  /// Generate a [ULID] from given bytes.
  /// [data] must be 16 bytes in length.
  ULID fromBytes(Uint8List data) {
    require(data.length == 16, "data must be 16 bytes in length");
    var mostSignificantBits = 0;
    var leastSignificantBits = 0;
    for (var i = 0; i < 8; i++) {
      mostSignificantBits = (mostSignificantBits << 8) | (data[i] & mask8Bits);
    }
    for (var i = 8; i < 16; i++) {
      leastSignificantBits =
          (leastSignificantBits << 8) | (data[i] & mask8Bits);
    }
    return ULID(mostSignificantBits, leastSignificantBits);
  }

  /// Create [ULID] object from given (valid) ULID [string].
  ULID fromString(String string) {
    require(string.length == 26, "ULID string must be exactly 26 chars long");

    final timeString = string.substring(0, 10);
    final time = timeString.parseCrockford();
    require((time & timestampOverflowMask) == 0,
        "ulid string must not exceed '7ZZZZZZZZZZZZZZZZZZZZZZZZZ'!");

    final part1 = string.substring(10, 18).parseCrockford();
    final part2 = string.substring(18).parseCrockford();

    final most = (time << 16) | (part1 >>> 24);
    final least = part2 | (part1 << 40);
    return ULID(most, least);
  }
}
