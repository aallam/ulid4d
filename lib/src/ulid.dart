import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'crockford.dart';
import 'ulid_factory.dart';
import 'utils.dart';

/// Universally Unique Lexicographically Sortable Identifier.
/// [Specification](https://github.com/ulid/spec#specification)
class ULID extends Comparable<ULID> {
  @internal
  ULID(this.mostSignificantBits, this.leastSignificantBits);

  /// Generate a [ULID].
  factory ULID.nextULID([int? timestamp]) => _factory.nextULID(timestamp);

  /// Generate a [ULID] from given bytes.
  /// [data] must be 16 bytes in length.
  factory ULID.fromBytes(Uint8List data) => _factory.fromBytes(data);

  /// Create [ULID] object from given (valid) ULID [string].
  factory ULID.fromString(String string) => _factory.fromString(string);

  /// Generate a ULID String.
  static String randomULID([int? timestamp]) => _factory.randomULID(timestamp);

  static final _factory = ULIDFactory();

  /// The most significant 64 bits of this ULID.
  final int mostSignificantBits;

  /// The least significant 64 bits of this ULID.
  final int leastSignificantBits;

  /// Get timestamp.
  int get timestamp => mostSignificantBits >>> 16;

  /// Generate the [Uint8List] for this [ULID].
  Uint8List toBytes() {
    final bytes = Uint8List(16);
    for (var i = 0; i < 8; i++) {
      bytes[i] = (mostSignificantBits >> ((7 - i) * 8)) & mask8Bits;
    }
    for (var i = 8; i < 16; i++) {
      bytes[i] = (leastSignificantBits >> ((15 - i) * 8)) & mask8Bits;
    }
    return bytes;
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
    final interim = leastSignificantBits >>> 40;
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
