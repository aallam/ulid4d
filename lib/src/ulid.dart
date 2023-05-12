import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import 'ulid_default.dart';

/// Universally Unique Lexicographically Sortable Identifier.
///
/// [ULID Specification](https://github.com/ulid/spec#specification)
abstract interface class ULID implements Comparable<ULID> {
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
