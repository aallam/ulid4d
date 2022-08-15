import 'dart:math';
import 'dart:typed_data';

import 'crockford.dart';
import 'time.dart';

class ULID extends Comparable<ULID> {

  factory ULID.nextULID(int timestamp) {
    requireTimestamp(timestamp);
    final random = Random();
    final buffer = Uint8List(26);
    const max8bit = 4294967295;
    buffer.write(timestamp, 10, 0);
    buffer.write(random.nextInt(max8bit), 8, 10);
    buffer.write(random.nextInt(max8bit), 8, 18);
    throw UnimplementedError();
  }

  static String randomULID(int timestamp) {
    requireTimestamp(timestamp);
    final random = Random();
    final buffer = Uint8List(26);
    const max8bit = 4294967295;
    buffer.write(timestamp, 10, 0);
    buffer.write(random.nextInt(max8bit), 8, 10);
    buffer.write(random.nextInt(max8bit), 8, 18);
    print(buffer);
    return String.fromCharCodes(buffer);
  }

  //int mostSignificantBits;
  //int leastSignificantBits;
  //int timestamp;

  Uint8List toBytes() {
    throw UnimplementedError();
  }

  @override
  int compareTo(ULID other) {
    throw UnimplementedError();
  }
}
