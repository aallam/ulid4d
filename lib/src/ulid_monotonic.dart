import 'ulid.dart';
import 'ulid_factory.dart';
import 'utils.dart';

/// Monotonic [ULID] factory.
///
/// [Specification](https://github.com/ulid/spec#monotonicity)
class ULIDMonotonic {
  /// Creates a [ULIDMonotonic] instance, with optional [factory].
  factory ULIDMonotonic([ULIDFactory? factory]) =>
      ULIDMonotonic._(factory ?? ULIDFactory());

  /// Create ULID factory with monotonic capabilities.
  const ULIDMonotonic._(this._factory);

  /// Internal ULID factory.
  final ULIDFactory _factory;

  /// Get the next monotonic [ULID].
  /// If an overflow happened while incrementing the random part of the given
  /// previous [ULID] value then the returned value will have a zero random
  /// part.
  ULID nextULID(ULID previous, [int? timestamp]) {
    timestamp = timestamp ?? currentTimestamp();
    if (previous.timestamp == timestamp) {
      return previous.increment();
    } else {
      return _factory.nextULID(timestamp);
    }
  }

  /// Generate the next monotonic [ULID], or returns `null` if an overflow
  /// happened while incrementing the random part of the given previous ULID.
  ULID? nextULIDStrict(ULID previous, [int? timestamp]) {
    final result = nextULID(previous, timestamp);
    return result.compareTo(previous) > 0 ? result : null;
  }
}
