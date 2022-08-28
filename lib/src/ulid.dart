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
class ULID implements Comparable<ULID> {
  /// Generate a [ULID].
  factory ULID.nextULID([int? timestamp]) => _factory.nextULID(timestamp);

  /// Generate a [ULID] from given bytes.
  /// [data] must be 16 bytes in length.
  factory ULID.fromBytes(Uint8List data) => _factory.fromBytes(data);

  /// Create [ULID] object from given (valid) ULID [string].
  factory ULID.fromString(String string) => _factory.fromString(string);

  /// Generate the next monotonic [ULID].
  /// If an overflow happened while incrementing the random part of the given
  /// previous [ULID] value then the returned value will have a zero random
  /// part.
  factory ULID.nextMonotonicULID(ULID previous, [int? timestamp]) =>
      _monotonic.nextULID(previous, timestamp);

  /// Generate the next monotonic [ULID], or returns `null` if an overflow
  /// happened while incrementing the random part of the given previous ULID.
  static ULID? nextMonotonicULIDStrict(ULID previous, [int? timestamp]) =>
      _monotonic.nextULIDStrict(previous, timestamp);

  /// Generate a ULID String.
  static String randomULID([int? timestamp]) => _factory.randomULID(timestamp);

  /// Internal default ULID factory.
  static final _factory = ULIDFactory();

  /// Internal monotonic default ULID factory.
  static final _monotonic = ULIDMonotonic(_factory);

  /// Internal [ULID] constructor.
  @internal
  const ULID.internal(this.mostSignificantBits, this.leastSignificantBits);

  /// The most significant 64 bits of this ULID.
  final Int64 mostSignificantBits;

  /// The least significant 64 bits of this ULID.
  final Int64 leastSignificantBits;

  /// Get timestamp.
  Int64 get timestamp => mostSignificantBits.shiftRightUnsigned(16);

  /// Generate the [Uint8List] for this [ULID].
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

  /// Get next valid [ULID] value.
  ULID increment() {
    if (leastSignificantBits != maxLSB) {
      return ULID.internal(mostSignificantBits, leastSignificantBits + 1);
    }
    if ((mostSignificantBits & mask16Bits) != mask16Bits) {
      return ULID.internal(mostSignificantBits + 1, Int64.ZERO);
    } else {
      return ULID.internal(mostSignificantBits & timestampMsbMask, Int64.ZERO);
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
    final buffer = Uint8List(26)..writeInt64(timestamp, 10, 0);
    var value = (mostSignificantBits & mask16Bits) << 24;
    final interim = leastSignificantBits.shiftRightUnsigned(40);
    value = value | interim;
    buffer
      ..writeInt64(value, 8, 10)
      ..writeInt64(leastSignificantBits, 8, 18);
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
