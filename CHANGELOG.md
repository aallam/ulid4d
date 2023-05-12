# 3.0.0-beta

### Changed
- Update to Dart 3

### Breaking Changes
- `ULID`, `ULIDFactory` and `ULIDMonotonic` can only be implemented.

# 2.0.0

### Fix

* Compatibility with js platform.

### Breaking

* `ULID`'s fields type change from `int` to `Int64`
    * `mostSignificantBits`
    * `leastSignificantBits`
    * `timestamp`

# 1.1.1

### Fix

* Expose monotonic factory to public API

# 1.1.0

### Added

* Monotonicity support

# 1.0.0

### Added

* ULID implementation
* Binary implementation support
