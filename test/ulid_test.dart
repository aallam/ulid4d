import 'package:test/test.dart';
import 'package:ulid_dart/src/ulid.dart';

import 'utils.dart';

void main() {
  group("Comparable", () {
    testComparable(0, 0, 0, 0, 0);
    testComparable(allBitsSet, allBitsSet, allBitsSet, allBitsSet, 0);
    testComparable(leftMostBits, rightMostBits, leftMostBits, rightMostBits, 0);
    testComparable(0, 1, 0, 0, 1);
    testComparable(1 << 16, 0, 0, 0, 1);
  });
}

void testComparable(int mostSignificantBits1, int leastSignificantBits1,
    int mostSignificantBits2, int leastSignificantBits2, int compare) {
  final value1 = ULID(mostSignificantBits1, leastSignificantBits1);
  final value2 = ULID(mostSignificantBits2, leastSignificantBits2);
  test('Compare $value1 and $value2', () {
    final equals12 = value1 == value2;
    final equals21 = value2 == value1;
    final compare12 = value1.compareTo(value2);
    final compare21 = value2.compareTo(value1);
    final hash1 = value1.hashCode;
    final hash2 = value2.hashCode;

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
