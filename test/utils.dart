import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

final pastTimestamp = Int64(1481195424879);
const pastTimestampPart = '01B3F2133F';
final maxTimestamp = Int64.parseHex('FFFFFFFFFFFF');
const maxTimestampPart = '7ZZZZZZZZZ';
const minTimestamp = Int64.ZERO;
const minTimestampPart = '0000000000';
const maxRandomPart = 'ZZZZZZZZZZZZZZZZ';
const minRandomPart = '0000000000000000';
final allBitsSet = Int64.parseHex('FFFFFFFFFFFFFFFF');
final patternMostSignificantBits = Int64.parseHex('0011223344556677');
final patternLeastSignificantBits = Int64.parseHex('8899AABBCCDDEEFF');
final zeroBytes = Uint8List(16);
final fullBytes = Uint8List.fromList(List.filled(16, 0xFF));
// @formatter:off
final patternBytes = Uint8List.fromList([
  0x00,
  0x11,
  0x22,
  0x33,
  0x44,
  0x55,
  0x66,
  0x77,
  0x88,
  0x99,
  0xAA,
  0xBB,
  0xCC,
  0xDD,
  0xEE,
  0xFF
]);
// @formatter:on

String timePartOf(String ulid) => ulid.substring(0, 10);

String randomPartOf(String ulid) => ulid.substring(10);

extension StringOperator on String {
  bool operator <(String other) => compareTo(other) < 0;

  bool operator <=(String other) => compareTo(other) <= 0;

  bool operator >(String other) => compareTo(other) > 0;

  bool operator >=(String other) => compareTo(other) >= 0;
}

class MockRandom implements Random {
  MockRandom([
    this.number = 0,
    this.boolean = true,
  ]);

  final bool boolean;
  final num number;

  @override
  bool nextBool() => boolean;

  @override
  double nextDouble() => number.toDouble();

  @override
  int nextInt(int max) => number.toInt();
}

extension IntExt on int {
  Int64 toInt64() => Int64(this);
}

extension StringExt on String {
  Int64 hexToInt64() => Int64.parseHex(this);
}
