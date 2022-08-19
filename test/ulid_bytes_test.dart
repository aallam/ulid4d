import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:ulid_dart/src/ulid.dart';

import 'utils.dart';

void main() {
  group('ULID to byte array', () {
    testToBytes(0, 0, zeroBytes);
    testToBytes(allBitsSet, allBitsSet, fullBytes);
    testToBytes(
        patternMostSignificantBits, patternLeastSignificantBits, patternBytes);
  });

  group('ULID from byte array', () {
    testFromBytes(zeroBytes, 0, 0);
    testFromBytes(fullBytes, allBitsSet, allBitsSet);
    testFromBytes(
        patternBytes, patternMostSignificantBits, patternLeastSignificantBits);
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
    int mostSignificantBits, int leastSignificantBits, Uint8List expectedData) {
  final ulid = ULID(mostSignificantBits, leastSignificantBits);
  test('$ulid to bytes', () {
    final bytes = ulid.toBytes();
    final bool equal = const ListEquality().equals(bytes, expectedData);
    expect(equal, true);
  });
}

/// Test convert byte array to [ULID].
void testFromBytes(
  Uint8List data,
  int mostSignificantBits,
  int leastSignificantBits,
) {
  final ulid = ULID.fromBytes(data);
  test('$ulid from byte array', () {
    expect(ulid.mostSignificantBits, mostSignificantBits);
    expect(ulid.leastSignificantBits, leastSignificantBits);
  });
}
