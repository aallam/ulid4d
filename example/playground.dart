import 'package:fixnum/fixnum.dart';

void main() {
  final x = Int64.parseHex('FFFFFFFFFFFF0000');
  final y = Int64.parseHex('0');
  final r = y.shiftRightUnsigned(y.toInt());
  print(r);
}