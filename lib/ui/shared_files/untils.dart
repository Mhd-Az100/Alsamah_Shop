import 'package:get/get.dart';

extension IsNullExt on String {
  String nullableValue(String spareValue) {
    if (GetUtils.isNull(this)) {
      return spareValue;
    } else {
      return this;
    }
  }
}
