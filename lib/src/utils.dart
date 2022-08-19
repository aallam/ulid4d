// maximum timestamp (32 high + 16 low bits)
const timestampOverflowMask = 0xFFFF000000000000;

const mask5Bits = 0x1F; // 32 encoding value (0..31)
const mask5BitsCount = 5;
const mask16Bits = 0xFFFF; // 16 bits mask
const mask8Bits = 0xFF; // 8 bits mask
const max32bit = 4294967295; // (2^32) - 1

/// Require valid timestamp.
void requireTimestamp(int timestamp) {
  require((timestamp & timestampOverflowMask) == 0,
      "ULID does not support timestamps after +10889-08-02T05:31:50.655Z!");
}

/// Require valid [condition].
void require(bool condition, [String? error]) {
  if (!condition) {
    throw ArgumentError(error ?? "Failed requirement.");
  }
}

/// Get current datetime in milliseconds.
int currentTimestamp() => DateTime.now().millisecondsSinceEpoch;
