import 'dart:math';
import 'dart:typed_data';

const pastTimestampPart = '01B3F2133F';
const maxTimestampPart = '7ZZZZZZZZZ';
const maxRandomPart = 'ZZZZZZZZZZZZZZZZ';
const minRandomPart = '0000000000000000';
const allBitsSet = 0xFFFFFFFFFFFFFFFF;
const leftMostBits = 0x0011223344556677;
const rightMostBits = 0x8899AABBCCDDEEFF;
final zeroBytes = Uint8List(16);
final fullBytes = Uint8List.fromList(List.filled(16, 0xFF));
// @formatter:off
final patternBytes = Uint8List.fromList([
  0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
  0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF
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
  bool nextBool() {
    return boolean;
  }

  @override
  double nextDouble() {
    return number.toDouble();
  }

  @override
  int nextInt(int max) {
    return number.toInt();
  }
}
