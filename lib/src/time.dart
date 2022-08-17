import 'constants.dart';

/// Require valid timestamp.
void requireTimestamp(int timestamp) {
  if ((timestamp & timestampOverflowMask) != 0) {
    throw ArgumentError(
        "ULID does not support timestamps after +10889-08-02T05:31:50.655Z!");
  }
}

/// Get current datetime in milliseconds.
int currentTimestamp() => DateTime.now().millisecondsSinceEpoch;
