import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';
import 'package:ulid4d/src/ulid.dart';
import 'package:ulid4d/src/ulid_monotonic.dart';

import 'utils.dart';

void main() {
  group('Generate next monotonic ULID', () {
    testNextMonotonic(
      const DefaultULID(Int64.ZERO, Int64.ZERO),
      const DefaultULID(
        Int64.ZERO,
        Int64.ONE,
      ),
    );
    testNextMonotonic(
      DefaultULID(Int64.ZERO, Int64.parseHex('FFFFFFFFFFFFFFFE')),
      DefaultULID(Int64.ZERO, Int64.parseHex('FFFFFFFFFFFFFFFF')),
    );
    testNextMonotonic(
      DefaultULID(Int64.ZERO, Int64.parseHex('FFFFFFFFFFFFFFFF')),
      const DefaultULID(Int64.ONE, Int64.ZERO),
    );
    testNextMonotonic(
      DefaultULID(Int64.parseHex('FFFF'), Int64.parseHex('FFFFFFFFFFFFFFFF')),
      const DefaultULID(Int64.ZERO, Int64.ZERO),
    );
  });

  test('Generate next monotonic ULID with timestamp mismatch', () {
    const previousValue = DefaultULID(Int64.ZERO, Int64.ZERO);
    final nextULID1 = ULID.nextMonotonicULID(previousValue, 1);
    expect(nextULID1.timestamp, Int64.ONE);

    final nextULID2 = ULID.nextMonotonicULID(previousValue);
    expect(nextULID2.timestamp > 0, true);
  });

  group('Generate next monotonic ULID strict.', () {
    testNextMonotonicStrict(
      const DefaultULID(Int64.ZERO, Int64.ZERO),
      const DefaultULID(Int64.ZERO, Int64.ONE),
    );
    testNextMonotonicStrict(
      DefaultULID(Int64.ZERO, Int64.parseHex('FFFFFFFFFFFFFFFE')),
      DefaultULID(Int64.ZERO, Int64.parseHex('FFFFFFFFFFFFFFFF')),
    );
    testNextMonotonicStrict(
      DefaultULID(Int64.ZERO, Int64.parseHex('FFFFFFFFFFFFFFFF')),
      const DefaultULID(Int64.ONE, Int64.ZERO),
    );
    testNextMonotonicStrict(
      DefaultULID(Int64.parseHex('FFFF'), Int64.parseHex('FFFFFFFFFFFFFFFF')),
      null,
    );
  });

  test('Generate next strict monotonic ULID with timestamp mismatch', () {
    const previousValue = DefaultULID(Int64.ZERO, Int64.ZERO);
    final nextULID1 = ULID.nextMonotonicULIDStrict(previousValue, 1);
    expect(nextULID1!.timestamp, Int64.ONE);

    final nextULID2 = ULID.nextMonotonicULIDStrict(previousValue);
    expect(nextULID2!.timestamp > 0, true);
  });

  test('Generate nextULID with monotonic factory', () {
    final monotonic = ULIDMonotonic();
    const previousValue = DefaultULID(Int64.ZERO, Int64.ZERO);
    final result = monotonic.nextULID(previousValue).toString();

    expect(result.length, 26);
    final timePart = timePartOf(result);
    final randomPart = randomPartOf(result);
    expect(pastTimestampPart < timePart, true);
    expect(maxTimestampPart >= timePart, true);
    expect(minRandomPart <= randomPart, true);
    expect(maxRandomPart >= randomPart, true);
  });
}

/// Test generate next monotonic ULID
void testNextMonotonic(
  ULID previousValue,
  ULID expectedResult,
) {
  final nextULID = ULID.nextMonotonicULID(previousValue, 0);
  test('Next monotonic of $previousValue', () {
    expect(nextULID, expectedResult);
  });
}

/// Test generate next monotonic ULID (strict)
void testNextMonotonicStrict(
  ULID previousValue,
  ULID? expectedResult,
) {
  final nextULID = ULID.nextMonotonicULIDStrict(previousValue, 0);
  test('Next strict monotonic of $previousValue', () {
    expect(nextULID, expectedResult);
  });
}
