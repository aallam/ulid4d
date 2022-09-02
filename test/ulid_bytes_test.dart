import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';
import 'package:ulid4d/src/ulid.dart';

import 'utils.dart';

void main() {
  group('ULID to byte array', () {
    testToBytes(Int64.ZERO, Int64.ZERO, zeroBytes);
    testToBytes(allBitsSet, allBitsSet, fullBytes);
    testToBytes(
      patternMostSignificantBits,
      patternLeastSignificantBits,
      patternBytes,
    );
  });

  group('ULID from byte array', () {
    testFromBytes(zeroBytes, Int64.ZERO, Int64.ZERO);
    testFromBytes(fullBytes, allBitsSet, allBitsSet);
    testFromBytes(
      patternBytes,
      patternMostSignificantBits,
      patternLeastSignificantBits,
    );
  });

  group('Invalid bytes', () {
    test('Short byte array', () {
      final short = Uint8List(15);
      expect(() => ULID.fromBytes(short), throwsArgumentError);
    });

    test('Long byte array', () {
      final long = Uint8List(17);
      expect(() => ULID.fromBytes(long), throwsArgumentError);
    });
  });
}

/// Test convert [ULID] to byte array.
void testToBytes(
  Int64 mostSignificantBits,
  Int64 leastSignificantBits,
  Uint8List expectedData,
) {
  final ulid = DefaultULID(mostSignificantBits, leastSignificantBits);
  test('$ulid to bytes', () {
    final bytes = ulid.toBytes();
    final equal = const ListEquality().equals(bytes, expectedData);
    expect(equal, true);
  });
}

/// Test convert byte array to [ULID].
void testFromBytes(
  Uint8List data,
  Int64 mostSignificantBits,
  Int64 leastSignificantBits,
) {
  final ulid = ULID.fromBytes(data);
  test('$ulid from byte array', () {
    expect(ulid.mostSignificantBits, mostSignificantBits);
    expect(ulid.leastSignificantBits, leastSignificantBits);
  });
}
