import 'package:test/test.dart';
import 'package:ulid_dart/src/time.dart';
import 'package:ulid_dart/ulid_dart.dart';

void main() {
  test('invalid timestamp', () {
    expect(() => requireTimestamp(0x0001000000000000),
        throwsA(TypeMatcher<ArgumentError>()));
  });
  
  test('random ULID', () {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var randomULID = ULID.randomULID(timestamp);
    print(randomULID);
  });
}
