import 'package:get/get.dart';
import 'package:waslcom/core/models/currency_model.dart';
import 'package:waslcom/core/services/storage_service.dart';

class CurrenciesController extends GetxController {
  ///I,ll use it in the next iteration
  CurrencyDto _currencyDto = Get.find<StorageService>().getCurrencyInfo();

  CurrencyDto get currencyDto => _currencyDto;

  set currencyDtoSet(CurrencyDto value) {
    _currencyDto = value;
    update();
  }
}
