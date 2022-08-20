import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:uuid/uuid.dart';

/// UUID Benchmark.
class UUIDBenchmark extends BenchmarkBase {
  const UUIDBenchmark() : super('UUID');

  static void execute() => const UUIDBenchmark().report();

  @override
  void run() => const Uuid().v4();
}
