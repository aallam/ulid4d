import 'package:ulid4d/src/ulid_monotonic.dart';
import 'package:ulid4d/ulid4d.dart';

void main() {
  // generate a ULID String
  final ulidString = ULID.randomULID();

  // generate a ULID instance
  final ulid = ULID.nextULID();

  // generate a byte array (Uint8List) a ULID instance
  final data = ulid.toBytes();

  // generate a ULID from given byte array using 'fromBytes'
  final ulidFromBytes = ULID.fromBytes(data);
  print(ulidFromBytes);

  // generate a ULID from given String using 'fromString'
  final ulidFromString = ULID.fromString(ulidString);
  print(ulidFromString);

  // generate a ULID String from ULID instance
  final ulidStringFromULID = ulid.toString();
  print(ulidStringFromULID);

  // generate ULID instance using a monotonic factory
  final ulidMono = ULID.nextMonotonicULID(ulid);

  // using a monotonic factory, generate a ULID instance or null in case
  // of overflow
  final ulidStrict = ULID.nextMonotonicULIDStrict(ulidMono);
  print(ulidStrict);

  // generate ULID using ULID monotonic factory
  final monotonic = ULIDMonotonic();
  final ulidFromMono = monotonic.nextULID(ulid);
  final ulidFromMonoStrict = monotonic.nextULIDStrict(ulidFromMono);
  print(ulidFromMonoStrict);
}
