import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import 'crockford.dart';
import 'ulid.dart';
import 'ulid_factory.dart';
import 'ulid_monotonic.dart';
import 'utils.dart';

/// Default implementation of [ULID].
final class DefaultULID implements ULID {
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
