import 'dart:typed_data';

import 'utils.dart';

extension CrockfordByte on Uint8List {
  /// [Crockford's Base 32](https://www.crockford.com/base32.html).
  void write(int value, int count, int offset) {
    for (var i = 0; i < count; i++) {
      final bitCount = (count - i - 1) * 5; // 5 bits, needed to encode 32 value
      final shifted = value >>> bitCount;
      final index = shifted & mask5Bits;
      this[offset + i] = encodingChars[index];
    }
  }
}

extension CrockfordString on String {
  /// [Crockford's Base 32](https://www.crockford.com/base32.html).
  int parseCrockford() {
    require(length <= 12, 'input length must not exceed 12 but was $length!');
    var result = 0;
    for (var i = 0; i < codeUnits.length; i++) {
      final current = codeUnits[i];
      var value = -1;
      if (current < decodingChars.length) {
        value = decodingChars[current];
      }
      require(
        value >= 0,
        "Illegal character '${String.fromCharCode(current)}'!",
      );
      final bitCount = (length - 1 - i) * mask5BitsCount;
      final shifted = value << bitCount;
      result = result | shifted;
    }
    return result;
  }
}

// @formatter:off

/// Crockford's base 32 encoding symbols (utf-8 int encodings).
/// [Specification](https://www.crockford.com/base32.html).
const List<int> encodingChars = [
  48, 49, 50, 51, 52, 53, 54, 55, 56, 57, // 0 - 9
  65, 66, 67, 68, 69, 70, 71, 72, 74, 75, // A - K
  77, 78, 80, 81, 82, 83, 84, 86, 87, 88, // M - X
  89, 90, // Y - Z
];

/// Crockford's base 32 decoding symbols. `-1` when not supported.
const decodingChars = [
  -1, -1, -1, -1, -1, -1, -1, -1, // 0
  -1, -1, -1, -1, -1, -1, -1, -1, // 8
  -1, -1, -1, -1, -1, -1, -1, -1, // 16
  -1, -1, -1, -1, -1, -1, -1, -1, // 24
  -1, -1, -1, -1, -1, -1, -1, -1, // 32
  -1, -1, -1, -1, -1, -1, -1, -1, // 40
  0, 1, 2, 3, 4, 5, 6, 7, // 48
  8, 9, -1, -1, -1, -1, -1, -1, // 56
  -1, 10, 11, 12, 13, 14, 15, 16, // 64
  17, 1, 18, 19, 1, 20, 21, 0, // 72
  22, 23, 24, 25, 26, -1, 27, 28, // 80
  29, 30, 31, -1, -1, -1, -1, -1, // 88
  -1, 10, 11, 12, 13, 14, 15, 16, // 96
  17, 1, 18, 19, 1, 20, 21, 0, // 104
  22, 23, 24, 25, 26, -1, 27, 28, // 112
  29, 30, 31 // 120
];
// @formatter:on
