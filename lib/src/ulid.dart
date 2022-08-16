import 'dart:math';
import 'dart:typed_data';

import 'package:ulid_dart/src/ulid_factory.dart';

import 'crockford.dart';
import 'time.dart';

class ULID extends Comparable<ULID> {
  static final _factory = ULIDFactory();

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

  static String randomULID([int? timestamp]) => _factory.randomULID(timestamp);

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
