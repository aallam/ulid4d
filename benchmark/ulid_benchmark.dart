import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ulid4d/ulid4d.dart';

/// ULID Benchmark.
class ULIDBenchmark extends BenchmarkBase {
  const ULIDBenchmark() : super('ULID');

  @override
  void run() => ULID.randomULID();
}
