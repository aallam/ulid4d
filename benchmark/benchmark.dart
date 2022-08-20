import 'ulid_benchmark.dart';
import 'uuid_benchmark.dart';

void main() {
  const ULIDBenchmark().report();
  const UUIDBenchmark().report();
}
