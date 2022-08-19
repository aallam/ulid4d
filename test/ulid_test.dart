import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:ulid_dart/src/ulid.dart';

import 'utils.dart';

void main() {
  group('Comparable ULID', () {
    testComparable(0, 0, 0, 0, 0);
    testComparable(allBitsSet, allBitsSet, allBitsSet, allBitsSet, 0);
    testComparable(leftMostBits, rightMostBits, leftMostBits, rightMostBits, 0);
    testComparable(0, 1, 0, 0, 1);
    testComparable(1 << 16, 0, 0, 0, 1);
  });

  group('ULID to bytes array', () {
    testToBytes(0, 0, zeroBytes);
    testToBytes(allBitsSet, allBitsSet, fullBytes);
    testToBytes(leftMostBits, rightMostBits, patternBytes);
  });
}

void testComparable(int mostSignificantBits1, int leastSignificantBits1,
    int mostSignificantBits2, int leastSignificantBits2, int compare) {
  final ulid1 = ULID(mostSignificantBits1, leastSignificantBits1);
  final ulid2 = ULID(mostSignificantBits2, leastSignificantBits2);
  test('Compare $ulid1 and $ulid2', () {
    final equals12 = ulid1 == ulid2;
    final equals21 = ulid2 == ulid1;
    final compare12 = ulid1.compareTo(ulid2);
    final compare21 = ulid2.compareTo(ulid1);
    final hash1 = ulid1.hashCode;
    final hash2 = ulid2.hashCode;

    expect(equals12, equals21);
    expect(compare12, compare21 * -1);

    if (compare == 0) {
      expect(hash1, hash2);
    } else {
      expect(compare12, compare);
      expect(equals12, false);
    }
  });
}

void testToBytes(
    int mostSignificantBits, int leastSignificantBits, Uint8List expectedData) {
  final ulid = ULID(mostSignificantBits, leastSignificantBits);
  test('$ulid to bytes', () {
    final bytes = ulid.toBytes();
    final bool equal = const ListEquality().equals(bytes, expectedData);
    expect(equal, true);
  });
}
