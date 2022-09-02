import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:meta/meta.dart';

import 'crockford.dart';
import 'ulid_factory.dart';
import 'ulid_monotonic.dart';
import 'utils.dart';

/// Universally Unique Lexicographically Sortable Identifier.
///
/// [ULID Specification](https://github.com/ulid/spec#specification)
abstract class ULID implements Comparable<ULID> {
  /// Generate a [ULID].
  factory ULID.nextULID([int? timestamp]) =>
      DefaultULID.factory.nextULID(timestamp);

  /// Generate a [ULID] from given bytes.
  /// [data] must be 16 bytes in length.
  factory ULID.fromBytes(Uint8List data) => DefaultULID.factory.fromBytes(data);

  /// Create [ULID] object from given (valid) ULID [string].
  factory ULID.fromString(String string) =>
      DefaultULID.factory.fromString(string);

  /// Generate the next monotonic [ULID].
  /// If an overflow happened while incrementing the random part of the given
  /// previous [ULID] value then the returned value will have a zero random
  /// part.
  factory ULID.nextMonotonicULID(ULID previous, [int? timestamp]) =>
      DefaultULID.monotonic.nextULID(previous, timestamp);

  /// Generate the next monotonic [ULID], or returns `null` if an overflow
  /// happened while incrementing the random part of the given previous ULID.
  static ULID? nextMonotonicULIDStrict(ULID previous, [int? timestamp]) =>
      DefaultULID.monotonic.nextULIDStrict(previous, timestamp);

  /// Generate a ULID String.
  static String randomULID([int? timestamp]) =>
      DefaultULID.factory.randomULID(timestamp);

  /// The most significant 64 bits of this ULID.
  Int64 get mostSignificantBits;

  /// The least significant 64 bits of this ULID.
  Int64 get leastSignificantBits;

  /// Get timestamp.
  Int64 get timestamp;

  /// Generate byte array [Uint8List] for this [ULID].
  Uint8List toBytes();

  /// Get next valid [ULID] value.
  ULID increment();
}

/// Default implementation of [ULID].
@visibleForTesting
class DefaultULID implements ULID {
  /// Creates [DefaultULID] instance.
  const DefaultULID(this.mostSignificantBits, this.leastSignificantBits);

  /// Internal default ULID factory.
  static final factory = ULIDFactory();

  /// Internal monotonic default ULID factory.
  static final monotonic = ULIDMonotonic(factory);

  @override
  final Int64 mostSignificantBits;

  @override
  final Int64 leastSignificantBits;

  @override
  Int64 get timestamp => mostSignificantBits.shiftRightUnsigned(16);

  @override
  Uint8List toBytes() {
    final bytes = Uint8List(16);
    for (var i = 0; i < 8; i++) {
      final value = (mostSignificantBits >> ((7 - i) * 8)) & mask8Bits;
      bytes[i] = value.toInt();
    }
    for (var i = 8; i < 16; i++) {
      final value = (leastSignificantBits >> ((15 - i) * 8)) & mask8Bits;
      bytes[i] = value.toInt();
    }
    return bytes;
  }

  @override
  ULID increment() {
    if (leastSignificantBits != maxLSB) {
      return DefaultULID(mostSignificantBits, leastSignificantBits + 1);
    }
    if ((mostSignificantBits & mask16Bits) != mask16Bits) {
      return DefaultULID(mostSignificantBits + 1, Int64.ZERO);
    } else {
      return DefaultULID(mostSignificantBits & timestampMsbMask, Int64.ZERO);
    }
  }

  @override
  int compareTo(ULID other) => mostSignificantBits < other.mostSignificantBits
      ? -1
      : mostSignificantBits > other.mostSignificantBits
          ? 1
          : leastSignificantBits < other.leastSignificantBits
              ? -1
              : leastSignificantBits > other.leastSignificantBits
                  ? 1
                  : 0;

  @override
  String toString() {
    final buffer = Uint8List(26)..write(timestamp, 10, 0);
    var value = (mostSignificantBits & mask16Bits) << 24;
    final interim = leastSignificantBits.shiftRightUnsigned(40);
    value = value | interim;
    buffer
      ..write(value, 8, 10)
      ..write(leastSignificantBits, 8, 18);
    return String.fromCharCodes(buffer);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ULID &&
          runtimeType == other.runtimeType &&
          mostSignificantBits == other.mostSignificantBits &&
          leastSignificantBits == other.leastSignificantBits;

  @override
  int get hashCode =>
      mostSignificantBits.hashCode ^ leastSignificantBits.hashCode;
}
