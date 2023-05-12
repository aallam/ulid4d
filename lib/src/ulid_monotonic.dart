import 'ulid.dart';
import 'ulid_factory.dart';
import 'utils.dart';

/// Monotonic [ULID] factory.
///
/// [Specification](https://github.com/ulid/spec#monotonicity)
abstract interface class ULIDMonotonic {
  /// Creates a [ULIDMonotonic] instance, with optional [factory].
  factory ULIDMonotonic([ULIDFactory? factory]) =>
      _ULIDMonotonic(factory ?? ULIDFactory());

  /// Get the next monotonic [ULID].
  /// If an overflow happened while incrementing the random part of the given
  /// previous [ULID] value then the returned value will have a zero random
  /// part.
  ULID nextULID(ULID previous, [int? timestamp]);

  /// Generate the next monotonic [ULID], or returns `null` if an overflow
  /// happened while incrementing the random part of the given previous ULID.
  ULID? nextULIDStrict(ULID previous, [int? timestamp]);
}

/// Default implementation of [ULIDMonotonic].
final class _ULIDMonotonic implements ULIDMonotonic {
  /// Creates ULID factory with monotonic capabilities.
  const _ULIDMonotonic(this.factory);

  /// Internal ULID factory.
  final ULIDFactory factory;

  @override
  ULID nextULID(ULID previous, [int? timestamp]) {
    final time = timestampOrCurrent(timestamp);
    if (previous.timestamp == time) {
      return previous.increment();
    } else {
      return factory.nextULID(time.toInt());
    }
  }

  @override
  ULID? nextULIDStrict(ULID previous, [int? timestamp]) {
    final result = nextULID(previous, timestamp);
    return result.compareTo(previous) > 0 ? result : null;
  }
}
