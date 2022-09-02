import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import 'crockford.dart';
import 'ulid.dart';
import 'utils.dart';

/// [ULID] factory builder.
class ULIDFactory {
  /// Creates a [ULIDFactory] instance, with optional [random] generator.
  factory ULIDFactory([Random? random]) => ULIDFactory._(random ?? Random());

  /// Default [ULIDFactory] constructor.
  const ULIDFactory._(this._random);

  /// Internal random generator.
  final Random _random;

  /// Generate a ULID String.
  String randomULID([int? timestamp]) {
    final time = timestampOrCurrent(timestamp);
    requireTimestamp(time);
    final buffer = Uint8List(26)
      ..write(time, 10, 0)
      ..write(_random.nextInt(max32bit).toInt64(), 8, 10)
      ..write(_random.nextInt(max32bit).toInt64(), 8, 18);
    return String.fromCharCodes(buffer);
  }

  /// Generate a [ULID].
  ULID nextULID([int? timestamp]) {
    final time = timestampOrCurrent(timestamp);
    requireTimestamp(time);
    var mostSignificantBits = _random.nextInt(max32bit).toInt64();
    final leastSignificantBits = _random.nextInt(max32bit).toInt64();
    mostSignificantBits = mostSignificantBits & mask16Bits; // random 16 bits
    mostSignificantBits =
        mostSignificantBits | (time << 16); // timestamp (32+16) + 16 random
    return ULID.internal(mostSignificantBits, leastSignificantBits);
  }

  /// Generate a [ULID] from given bytes.
  /// [data] must be 16 bytes in length.
  ULID fromBytes(Uint8List data) {
    require(data.length == 16, 'data must be 16 bytes in length');
    var mostSignificantBits = Int64.ZERO;
    var leastSignificantBits = Int64.ZERO;
    for (var i = 0; i < 8; i++) {
      mostSignificantBits = (mostSignificantBits << 8) | (data[i] & mask8Bits);
    }
    for (var i = 8; i < 16; i++) {
      leastSignificantBits =
          (leastSignificantBits << 8) | (data[i] & mask8Bits);
    }
    return ULID.internal(mostSignificantBits, leastSignificantBits);
  }

  /// Create [ULID] object from given (valid) ULID [string].
  ULID fromString(String string) {
    require(string.length == 26, 'ULID string must be exactly 26 chars long');

    final timeString = string.substring(0, 10);
    final time = timeString.parseCrockford();
    require(
      (time & timestampOverflowMask) == 0,
      "ulid string must not exceed '7ZZZZZZZZZZZZZZZZZZZZZZZZZ'!",
    );

    final part1 = string.substring(10, 18).parseCrockford();
    final part2 = string.substring(18).parseCrockford();

    final most = (time << 16) | part1.shiftRightUnsigned(24);
    final least = part2 | (part1 << 40);
    return ULID.internal(most, least);
  }
}
