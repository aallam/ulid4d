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

  // generate a ULID from given String using 'fromString'
  final ulidFromString = ULID.fromString(ulidString);

  // generate a ULID String from ULID instance
  final ulidStringFromULID = ulid.toString();
}
