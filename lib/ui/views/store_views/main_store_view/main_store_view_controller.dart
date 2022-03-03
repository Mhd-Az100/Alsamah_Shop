import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connection_verify/connection_verify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waslcom/core/models/gallery_model.dart';
import 'package:waslcom/core/models/main_store_view_models.dart';
import 'package:waslcom/core/network.dart';
import 'package:waslcom/core/repos/store_repo.dart';
import 'package:waslcom/core/services/check_app_version.dart';
import 'package:waslcom/core/utils/general_utils.dart';
import 'package:waslcom/ui/views/store_views/categories_store_view/categories_view.dart';
import 'package:waslcom/ui/views/store_views/offers/offers_view.dart';
import 'package:waslcom/core/repos/app_properties_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class MainStoreController extends GetxController {
  ///---------------------------------------------------------------------------

  ///---------------------------------------------------------------------------
  ///Loading indicator

  RxBool isLoading = false.obs;

  ///---------------------------------------------------------------------------
  ///Connection error indicator

  RxBool connectionError = false.obs;

  ///---------------------------------------------------------------------------
  ///Get Stores List

  var storesList = <StoreModel>[];

  Future getStores() async {
    try {
      storesList = await StoreRepository.getStores();
    } catch (e) {
      log(e.toString(), name: "Get stores func error");
    } finally {}
    update();
  }

  StoreModel getData(int index) => storesList[index];

  ///---------------------------------------------------------------------------
  ///Gallery
//check deliverytime
  String marqueeText = '';
  void getmerqueetext() async {
    var marquee = await AppPropertiesRepo.getMarqee();
    marqueeText = marquee;
  }

  String payment = '';
  void getpayment() async {
    var pay = await AppPropertiesRepo.getpaymentstate();
    payment = pay;
  }

  List<CachedNetworkImage> _galleryImages = <CachedNetworkImage>[];
  List<String> _targetImageList = <String>[];

  List<CachedNetworkImage> get galleryImages => _galleryImages;
  List<String> get targetImageList => _targetImageList;

  Future getGalleryImages() async {
    try {
      List<GalleryModel> _galleryModelList = <GalleryModel>[];
      await StoreRepository.getGalleryImages().then((responseList) {
        _galleryModelList =
            responseList.map((e) => GalleryModel.fromJson(e)).toList();
        _targetImageList =
            responseList.map((e) => GalleryModel.fromJson(e).target).toList();

        if (_galleryModelList.isNotEmpty) {
          _galleryImages = _galleryModelList.map((e) {
            // marqueeText += '${e.target ?? ""}\t🔷';
            return CachedNetworkImage(
              imageUrl: NetworkUtils.MEDIA_API + "${e?.media?.id}",
              fit: BoxFit.cover,
            );
          }).toList();
        }
      });
    } catch (e) {
      log(e.toString(), name: "[Parent_route:Controller:Gallery:error :]");
    }
  }

  void lunchUrl(
    int index,
  ) async {
    String target = _targetImageList[index];
    try {
      if (await canLaunch(target)) {
        await launch(target, forceSafariVC: false, forceWebView: false);
      } else {
        log('Could not launch $target', name: "lunchLinks func error: ");
      }
      // await lunchUrl(target);
      BotToast.showLoading();
    } catch (e) {
      log(e.toString(), name: "lunchLinks error: ");
    } finally {
      BotToast.closeAllLoading();
    }
  }

  ///Tap item action
  void tapItemAction(int index) {
    String _isOffer = getData(index).status;
    if ((_isOffer?.isNotEmpty ?? false) && (_isOffer == "Is offer")) {
      Get.to(() => OffersView());
    } else {
      Get.to(() => CategoriesView(
            id: getData(index).id.toString(),
            title: getData(index).name,
          ));
    }
  }

  ///---------------------------------------------------------------------------
  ///onInitial
  void onInitial() async {
    try {
      getmerqueetext();
      getpayment();
      isLoading(true);
      if (await ConnectionVerify.connectionStatus()) {
        connectionError(false);
        if (GeneralUtils.getStorageService.isCompleteLoginAccount)
          await AppVersioningService.checkAppVersion();
        await getGalleryImages();
        await getStores();
      } else {
        connectionError(true);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  ///---------------------------------------------------------------------------
  @override
  void onInit() {
    onInitial();
    super.onInit();
  }
}
