import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:ulid_dart/src/ulid_factory.dart';

import 'constants.dart';
import 'crockford.dart';

/// Universally Unique Lexicographically Sortable Identifier.
/// [Specification](https://github.com/ulid/spec#specification)
class ULID extends Comparable<ULID> {
  @internal
  ULID(this.mostSignificantBits, this.leastSignificantBits);

  /// Generate a [ULID].
  factory ULID.nextULID([int? timestamp]) => _factory.nextULID(timestamp);

  /// Generate a ULID String.
  static String randomULID([int? timestamp]) => _factory.randomULID(timestamp);

  static final _factory = ULIDFactory();

  /// The most significant 64 bits of this ULID.
  final int mostSignificantBits;

  /// The least significant 64 bits of this ULID.
  final int leastSignificantBits;

  /// Get timestamp.
  int get timestamp => mostSignificantBits >> 16;

  @override
  int compareTo(ULID other) {
    if (mostSignificantBits < other.mostSignificantBits ||
        leastSignificantBits < other.leastSignificantBits) {
      return -1;
    } else if (mostSignificantBits > other.mostSignificantBits ||
        leastSignificantBits > other.leastSignificantBits) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  String toString() {
    final buffer = Uint8List(26);
    buffer.write(timestamp, 10, 0);
    var value = (mostSignificantBits & mask16Bits) << 24;
    final interim = leastSignificantBits >>> 40;
    value = value & interim;
    buffer.write(value, 8, 10);
    buffer.write(leastSignificantBits, 8, 18);
    return String.fromCharCodes(buffer);
  }
}
