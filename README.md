# ULID for Dart

[![pub package](https://img.shields.io/pub/v/ulid4d.svg)](https://pub.dev/packages/ulid4d)
[![codecov](https://codecov.io/gh/Aallam/ulid4d/branch/main/graph/badge.svg?token=VSK7FYJTAA)](https://codecov.io/gh/Aallam/ulid4d)

Universally Unique Lexicographically Sortable Identifier ([ULID](https://github.com/ulid/spec#specification)) implementation for Dart, with binary implementation and monotonicity support.

## Background

UUID can be suboptimal for many use-cases because:

- It isn't the most character efficient way of encoding 128 bits of randomness
- UUID v1/v2 is impractical in many environments, as it requires access to a unique, stable MAC address
- UUID v3/v5 requires a unique seed and produces randomly distributed IDs, which can cause fragmentation in many data
  structures
- UUID v4 provides no other information than randomness which can cause fragmentation in many data structures

Instead, herein is proposed ULID:

- 128-bit compatibility with UUID
- 1.21e+24 unique ULIDs per millisecond
- Lexicographically sortable!
- Canonically encoded as a 26 character string, as opposed to the 36 character UUID
- Uses Crockford's base32 for better efficiency and readability (5 bits per character)
- Case-insensitive
- No special characters (URL safe)
- Monotonic sort order (correctly detects and handles the same millisecond)

## Usage

* Generate _ULID_ String:

```dart
var ulid = ULID.randomULID();
```

* Generate `ULID` instance:

```dart
var ulid = ULID.nextULID();
var ulidString = ulid.toString();
```

* Generate `ULID` using `ULIDFactory`

```dart
var factory = ULIDFactory();
var ulid = factory.nextULID();
var ulidString = ulid.toString();
```

_You can use `ULIDFactory(Random)` to use a different `Random` instance._

* Generating `ULID` from/to bytes

```dart
// generate a ULID instance
var ulid = ULID.nextULID();

// generate byte array (Uint8List) of ULID instance
var data = ulid.toBytes();

// generate a ULID from given byte array using 'fromBytes'
var ulidFromBytes = ULID.fromBytes(data);
```

* Generate `ULID` from/to _ULID_ string

````dart
// generate a ULID string
var ulidString = ULID.randomULID();

// generate a ULID from given String using 'fromString'
var ulidFromString = ULID.fromString(ulidString);

// generate a ULID String from ULID instance
var ulidStringFromULID = ulid.toString();
````

### Monotonicity

* Generate monotonic `ULID`

```dart
// generate ULID instance using a monotonic factory
var ulid = ULID.nextMonotonicULID(ulid);

// using a monotonic factory, generate a ULID instance or null in case
// of overflow
var ulidStrict = ULID.nextMonotonicULIDStrict(ulidMono);
```

* Generate `ULID` using `ULIDMonocity` factory

```dart
// generate ULID using ULID monotonic factory
var factory = ULIDMonotonic();
var ulid = factory.nextULID(ulid);
var ulidStrict = factory.nextULIDStrict(ulid);
```

## Specification

Below is the current specification of ULID as implemented in this repository.

### Components

**Timestamp**

- 48 bits
- UNIX-time in milliseconds
- Won't run out of space till the year 10889 AD

**Entropy**

- 80 bits
- User defined entropy source.

### Encoding

[Crockford's Base32](https://www.crockford.com/wrmg/base32.html) is used as shown.
This alphabet excludes the letters I, L, O, and U to avoid confusion and abuse.

```
0123456789ABCDEFGHJKMNPQRSTVWXYZ
```

### Binary Layout and Byte Order

The components are encoded as 16 octets. Each component is encoded with the Most Significant Byte first (network byte
order).

```
0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                      32_bit_uint_time_high                    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     16_bit_uint_time_low      |       16_bit_uint_random      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       32_bit_uint_random                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       32_bit_uint_random                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

### String Representation

```
 01AN4Z07BY      79KA1307SR9X4MV3
|----------|    |----------------|
 Timestamp           Entropy
  10 chars           16 chars
   48bits             80bits
   base32             base32
```

## Prior Art

- [Aallam/ulid-kotlin](https://github.com/Aallam/ulid-kotlin)

## License

ulid4d is an open-sourced software licensed under the [BSD 3-clause license](LICENSE).
