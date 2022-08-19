import 'dart:math';

const pastTimestampPart = '01B3F2133F';
const maxTimestampPart = '7ZZZZZZZZZ';
const maxRandomPart = 'ZZZZZZZZZZZZZZZZ';
const minRandomPart = '0000000000000000';
const allBitsSet = 0xFFFFFFFFFFFFFFFF;
const leftMostBits = 0x0011223344556677;
const rightMostBits = 0x8899AABBCCDDEEFF;

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
