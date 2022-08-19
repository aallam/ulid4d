import 'package:test/test.dart';
import 'package:ulid4d/src/ulid.dart';
import 'package:ulid4d/src/ulid_monotonic.dart';

import 'utils.dart';

void main() {
  group('Generate next monotonic ULID', () {
    testNextMonotonic(const ULID.internal(0, 0), const ULID.internal(0, 1));
    testNextMonotonic(
      const ULID.internal(0, 0xFFFFFFFFFFFFFFFE),
      const ULID.internal(0, 0xFFFFFFFFFFFFFFFF),
    );
    testNextMonotonic(
      const ULID.internal(0, 0xFFFFFFFFFFFFFFFF),
      const ULID.internal(1, 0),
    );
    testNextMonotonic(
      const ULID.internal(0xFFFF, 0xFFFFFFFFFFFFFFFF),
      const ULID.internal(0, 0),
    );
  });

  test('Generate next monotonic ULID with timestamp mismatch', () {
    const previousValue = ULID.internal(0, 0);
    final nextULID1 = ULID.nextMonotonicULID(previousValue, 1);
    expect(nextULID1.timestamp, 1);

    final nextULID2 = ULID.nextMonotonicULID(previousValue);
    expect(nextULID2.timestamp > 0, true);
  });

  group('Generate next monotonic ULID strict.', () {
    testNextMonotonicStrict(
      const ULID.internal(0, 0),
      const ULID.internal(0, 1),
    );
    testNextMonotonicStrict(
      const ULID.internal(0, 0xFFFFFFFFFFFFFFFE),
      const ULID.internal(0, 0xFFFFFFFFFFFFFFFF),
    );
    testNextMonotonicStrict(
      const ULID.internal(0, 0xFFFFFFFFFFFFFFFF),
      const ULID.internal(1, 0),
    );
    testNextMonotonicStrict(
      const ULID.internal(0xFFFF, 0xFFFFFFFFFFFFFFFF),
      null,
    );
  });

  test('Generate next strict monotonic ULID with timestamp mismatch', () {
    const previousValue = ULID.internal(0, 0);
    final nextULID1 = ULID.nextMonotonicULIDStrict(previousValue, 1);
    expect(nextULID1!.timestamp, 1);

    final nextULID2 = ULID.nextMonotonicULIDStrict(previousValue);
    expect(nextULID2!.timestamp > 0, true);
  });

  test('Generate nextULID with monotonic factory', () {
    final monotonic = ULIDMonotonic();
    const previousValue = ULID.internal(0, 0);
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
