import 'constants.dart';

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
