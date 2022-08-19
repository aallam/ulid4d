// maximum timestamp (32 high + 16 low bits)
const timestampOverflowMask = 0xFFFF000000000000;

const mask5Bits = 0x1F; // 32 encoding value (0..31)
const mask5BitsCount = 5;
const mask16Bits = 0xFFFF; // 16 bits mask
const mask8Bits = 0xFF; // 8 bits mask

const max32bit = 4294967295; // (2^32) - 1
