import 'package:test/test.dart';
import 'package:ulid_dart/src/time.dart';
import 'package:ulid_dart/src/ulid_factory.dart';
import 'package:ulid_dart/ulid_dart.dart';

import 'utils.dart';

void main() {
  test('invalid timestamp', () {
    expect(() => requireTimestamp(0x0001000000000000),
        throwsA(TypeMatcher<ArgumentError>()));
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
}
