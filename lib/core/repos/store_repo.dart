import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:waslcom/core/models/categories_view_model.dart';
import 'package:waslcom/core/models/main_store_view_models.dart';
import 'package:waslcom/core/models/subcategories_products_model.dart';
import 'package:waslcom/core/network.dart';

class StoreRepository {
  static Map<String, String> headers = {"accept": "application/json"};

  ///---------------------------------------------------------------------------
  ///End-points
  static const Stores = "Stores";
  static const Categories = "Categories/StoreCategories/";
  static const SubCategories = "Categories/ChildrenCategories/";
  static const products = "Products/CategoryProducts/";
  static const offers = "Products/Offers/";
  static const Search = "Products/Search/";
  static const Barcode = "Products/BySKU/";
  static const Gallery = "Gallery";
  static const productsAttribute = "Products/AttributesKeys";

  ///---------------------------------------------------------------------------
  ///Get Stores
  static Future<List<StoreModel>> getStores() async {
    var _responseList = <dynamic>[];
    var _storeModelList = <StoreModel>[];
    http.Response response =
        await NetworkUtils.get(url: Stores, headers: headers);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "GetStores response");
      _responseList = json.decode(response.body);
      _storeModelList =
          _responseList.map((e) => StoreModel.fromJson(e)).toList();
      return _storeModelList
          .where((element) => element.notes != "disable")
          .toList();
    } else {
      log(response.statusCode.toString(), name: "Get stores api error");
      return _storeModelList;
    }
  }

  ///---------------------------------------------------------------------------
  ///Get Categories
  static Future<List<CategoriesModel>> getCategories(String id) async {
    var _responseList = <dynamic>[];
    var _finalList = <CategoriesModel>[];
    http.Response response =
        await NetworkUtils.get(url: Categories + id, headers: headers);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getCategories response");
      _responseList = json.decode(response.body);
      _finalList =
          _responseList.map((e) => CategoriesModel.fromJson(e)).toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(), name: "Get getCategories api error");
      return _finalList;
    }
  }

  ///---------------------------------------------------------------------------
  ///Get SubCategories and products
  static Future<List<SubCategoriesAndProductsModel>> getSubCategories(
      String id) async {
    var _responseList = <dynamic>[];
    var _finalList = <SubCategoriesAndProductsModel>[];
    http.Response response =
        await NetworkUtils.get(url: SubCategories + id, headers: headers);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getSubCategories response");
      _responseList = json.decode(response.body);
      _finalList = _responseList
          .map((e) =>
              SubCategoriesAndProductsModel.fromJson(e)..isProduct = false)
          .where((element) => (!(element?.hidden ?? false)))
          .toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(),
          name: "Get getSubCategories api error");
      return _finalList;
    }
  }

  static Future<List<SubCategoriesAndProductsModel>> getProducts(String id,
      {int pageSize = 100, int pageIndex = 1}) async {
    var _responseList = <dynamic>[];
    var _finalList = <SubCategoriesAndProductsModel>[];
    http.Response response = await NetworkUtils.get(
        url: products + id + "?page=$pageIndex&count=$pageSize",
        headers: headers);
    log(json.decode(response.body).toString(), name: "getProducts Response :");
    if (response.statusCode == 200) {
      _responseList = json.decode(response.body);
      try {
        _finalList = _responseList
            .map((e) =>
                SubCategoriesAndProductsModel.fromJson(e)..isProduct = true)
            .toList();
        return _finalList.where((element) => !element.hidden).toList();
      } catch (e) {
        log(e.toString(), name: "Get getProducts api error");
      }
    } else {
      log(response.statusCode.toString(), name: "Get getProducts api error");
      return _finalList;
    }
  }

  static Future<List<SubCategoriesAndProductsModel>> getOffers(
      {int pageSize = 100, int pageIndex = 1}) async {
    var _responseList = <dynamic>[];
    var _finalList = <SubCategoriesAndProductsModel>[];
    http.Response response =
        await NetworkUtils.get(url: offers, headers: headers);
    log(json.decode(response.body).toString(), name: "getOffers Response :");
    if (response.statusCode == 200) {
      _responseList = json.decode(response.body);
      _finalList = _responseList
          .map((e) =>
              SubCategoriesAndProductsModel.fromJson(e)..isProduct = true)
          .toList();
      return _finalList.where((element) => !element.hidden).toList();
    } else {
      log(response.statusCode.toString(), name: "Get getOffers api error");
      return _finalList;
    }
  }

  static Future<List<SubCategoriesAndProductsModel>> searchRequest(String value,
      {int pageSize = 100, int pageIndex = 1}) async {
    var _responseList = <dynamic>[];
    var _finalList = <SubCategoriesAndProductsModel>[];
    http.Response response = await NetworkUtils.get(
        url: Search + value + "?page=$pageIndex&count=$pageSize",
        headers: headers);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getProducts response");
      _responseList = json.decode(response.body);
      _finalList = _responseList
          .map((e) => SubCategoriesAndProductsModel.fromJson(e))
          .toList();
      return _finalList;
    } else {
      log(response.statusCode.toString(), name: "Get getProducts api error");
      return _finalList;
    }
  }

  ///---------------------------------------------------------------------------
  ///Gallery
  static Future<List<dynamic>> getGalleryImages() async {
    List<dynamic> _responseList = <dynamic>[];
    try {
      http.Response response =
          await NetworkUtils.get(url: Gallery, headers: headers);
      if (response.statusCode == 200) {
        _responseList = jsonDecode(response.body);
        log(response.body, name: "[API:Controller:Gallery:Success :]");
      }
    } catch (e) {
      log(e.toString(), name: "[API:Controller:Gallery:error :]");
    }
    return _responseList;
  }

  //===============================================================================
  ///Barcode
  static Future<SubCategoriesAndProductsModel> searchByBarcode(
    String value,
  ) async {
    SubCategoriesAndProductsModel _finalList;
    http.Response response =
        await NetworkUtils.get(url: Barcode + value, headers: headers);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: "getProducts response");
      var body = json.decode(response.body);
      _finalList = SubCategoriesAndProductsModel.fromJson(body);
      return _finalList;
    } else {
      log(response.statusCode.toString(), name: "Get getProducts api error");
      return _finalList;
    }
  }

  //==================================================================================
  // product Attribute
  // static Future<List<GlobalProductAttribute>> getProductAttribbute() async {
  //   List<GlobalProductAttribute> _finalList;
  //   http.Response response =
  //       await NetworkUtils.get(url: productsAttribute, headers: headers);
  //   if (response.statusCode == 200) {
  //     log(response.body.toString(), name: "getProducts attribute response");
  //     var body = json.decode(response.body);
  //     for (var item in body) {
  //       _finalList.add(GlobalProductAttribute.fromJson(item));
  //     }

  //     return _finalList;
  //   } else {
  //     log(response.statusCode.toString(),
  //         name: "Get getProducts attribute api error");
  //     return _finalList;
  //   }
  // }
}
