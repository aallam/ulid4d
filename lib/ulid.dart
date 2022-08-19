/// Universally Unique Lexicographically Sortable Identifier
///
/// - 128-bit compatibility with UUID
/// - 1.21e+24 unique ULIDs per millisecond
/// - Lexicographically sortable!
/// - Canonically encoded as a 26 character string, as opposed to the 36
/// character UUID
/// - Uses Crockford's base32 for better efficiency and readability (5 bits per
/// character)
/// - Case-insensitive
/// - No special characters (URL safe)
library ulid;

export 'src/ulid.dart';
export 'src/ulid_factory.dart';
