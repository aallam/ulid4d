import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';
import 'package:ulid4d/src/ulid.dart';
import 'package:ulid4d/src/ulid_factory.dart';
import 'package:ulid4d/src/utils.dart';

import 'utils.dart';

void main() {
  test('invalid timestamp', () {
    expect(
      () => requireTimestamp(Int64(0x0001000000000000)),
      throwsArgumentError,
    );
  });

  test('random ULID', () {
    final ulid = ULID.randomULID();

    expect(ulid.length, 26);

    final timePart = timePartOf(ulid);
    final randomPart = randomPartOf(ulid);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(minRandomPart <= randomPart, true);
    expect(maxRandomPart >= randomPart, true);
  });

  test('random ULID with random 0', () {
    final random = MockRandom();
    final factory = ULIDFactory(random);
    final ulid = factory.randomULID();

    expect(random.nextInt(100), 0);
    expect(ulid.length, 26);

    final timePart = timePartOf(ulid);
    final randomPart = randomPartOf(ulid);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(randomPart, minRandomPart);
  });

  test('random ULID with random -1', () {
    final random = MockRandom(-1);
    final factory = ULIDFactory(random);
    final ulid = factory.randomULID();

    expect(random.nextInt(100), -1);
    expect(ulid.length, 26);

    final timePart = timePartOf(ulid);
    final randomPart = randomPartOf(ulid);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(randomPart, maxRandomPart);
  });

  test('next ULID', () {
    final ulid = ULID.nextULID().toString();

    expect(ulid.length, 26);

    final timePart = timePartOf(ulid);
    final randomPart = randomPartOf(ulid);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(minRandomPart <= randomPart, true);
    expect(maxRandomPart >= randomPart, true);
  });

  test('next ULID with random 0', () {
    final random = MockRandom();
    final factory = ULIDFactory(random);
    final ulid = factory.nextULID().toString();

    expect(random.nextInt(100), 0);
    expect(ulid.length, 26);

    final timePart = timePartOf(ulid);
    final randomPart = randomPartOf(ulid);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(randomPart, minRandomPart);
  });

  test('random ULID with random -1', () {
    final random = MockRandom(-1);
    final factory = ULIDFactory(random);
    final ulid = factory.nextULID().toString();

    expect(random.nextInt(100), -1);
    expect(ulid.length, 26);

    final timePart = timePartOf(ulid);
    final randomPart = randomPartOf(ulid);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(randomPart, maxRandomPart);
  });

  group('Comparable ULID', () {
    testComparable(Int64.ZERO, Int64.ZERO, Int64.ZERO, Int64.ZERO, Int64.ZERO);
    testComparable(allBitsSet, allBitsSet, allBitsSet, allBitsSet, Int64.ZERO);
    testComparable(
      patternMostSignificantBits,
      patternLeastSignificantBits,
      patternMostSignificantBits,
      patternLeastSignificantBits,
      Int64.ZERO,
    );
    testComparable(Int64.ZERO, Int64.ONE, Int64.ZERO, Int64.ZERO, Int64.ONE);
    testComparable(
      Int64.ONE << 16,
      Int64.ZERO,
      Int64.ZERO,
      Int64.ZERO,
      Int64.ONE,
    );
  });

  group('Parse valid ULID ', () {
    testParseValidULID('${pastTimestampPart}0000000000000000', pastTimestamp);
    testParseValidULID('${pastTimestampPart}ZZZZZZZZZZZZZZZZ', pastTimestamp);
    testParseValidULID('${pastTimestampPart}123456789ABCDEFG', pastTimestamp);
    testParseValidULID('${pastTimestampPart}1000000000000000', pastTimestamp);
    testParseValidULID('${pastTimestampPart}1000000000000001', pastTimestamp);
    testParseValidULID('${pastTimestampPart}0001000000000001', pastTimestamp);
    testParseValidULID('${pastTimestampPart}0100000000000001', pastTimestamp);
    testParseValidULID('${pastTimestampPart}0000000000000001', pastTimestamp);
    testParseValidULID('${minTimestampPart}123456789ABCDEFG', minTimestamp);
    testParseValidULID('${maxTimestampPart}123456789ABCDEFG', maxTimestamp);
  });

  group('Parse ULID with excluded chars', () {
    testParseExcludedULID(
      '${pastTimestampPart}0l00000000000000',
      '${pastTimestampPart}0100000000000000',
      pastTimestamp,
    );
    testParseExcludedULID(
      '${pastTimestampPart}0L00000000000000',
      '${pastTimestampPart}0100000000000000',
      pastTimestamp,
    );
    testParseExcludedULID(
      '${pastTimestampPart}0i00000000000000',
      '${pastTimestampPart}0100000000000000',
      pastTimestamp,
    );
    testParseExcludedULID(
      '${pastTimestampPart}0I00000000000000',
      '${pastTimestampPart}0100000000000000',
      pastTimestamp,
    );
    testParseExcludedULID(
      '${pastTimestampPart}0o00000000000000',
      '${pastTimestampPart}0000000000000000',
      pastTimestamp,
    );
    testParseExcludedULID(
      '${pastTimestampPart}0O00000000000000',
      '${pastTimestampPart}0000000000000000',
      pastTimestamp,
    );
  });

  group('Parse invalid ULID string', () {
    testParseInvalidULID('0000000000000000000000000');
    testParseInvalidULID('000000000000000000000000000');
    testParseInvalidULID('80000000000000000000000000');
  });
}

/// Test comparability of [ULID] objects.
void testComparable(
  Int64 mostSignificantBits1,
  Int64 leastSignificantBits1,
  Int64 mostSignificantBits2,
  Int64 leastSignificantBits2,
  Int64 compare,
) {
  final ulid1 = DefaultULID(mostSignificantBits1, leastSignificantBits1);
  final ulid2 = DefaultULID(mostSignificantBits2, leastSignificantBits2);
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

/// Test parse valid ULID string.
void testParseValidULID(String string, Int64 expectedTimestamp) {
  test('Parse $string', () {
    final ulid = ULID.fromString(string);
    expect(ulid.toString(), string);
    expect(ulid.timestamp, expectedTimestamp);
  });
}

/// Test parse valid ULID string with excluded chars (I,L,O,U).
void testParseExcludedULID(
  String string,
  String expectedString,
  Int64 expectedTimestamp,
) {
  test('Parse $string', () {
    final ulid = ULID.fromString(string);
    expect(ulid.toString(), expectedString);
    expect(ulid.timestamp, expectedTimestamp);
  });
}

/// Test parse invalid ULID.
void testParseInvalidULID(String string) {
  test('Parse $string', () {
    expect(() => ULID.fromString(string), throwsArgumentError);
  });
}
