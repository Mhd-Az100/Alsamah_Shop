import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:waslcom/core/utils/get_file_from_assets_util.dart';


class SharedCachedNetworkImage {
  static getCachedNetworkImage({@required imageUrl,
    Size size,
    bool forProductDetails = false,
    bool showPlaceHolder = true,
  }) =>
      CachedNetworkImage(
        imageUrl: imageUrl ?? "",
        imageBuilder: (context, imageProvider) =>
            Container(
              decoration: BoxDecoration(
                borderRadius: forProductDetails
                    ? BorderRadius.circular(0)
                    : BorderRadius.circular(10.0),
                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              ),
            ),
        fit: BoxFit.fill,
        progressIndicatorBuilder: showPlaceHolder
            ? null
            : (context, url, progress) =>
            Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
        placeholderFadeInDuration:
        showPlaceHolder ? Duration(seconds: 1) : null,
        placeholder: showPlaceHolder
            ? (context, url) =>
            Image.asset(
              AssetsUtils.appPlaceHolderLogo,
              fit: BoxFit.scaleDown,
            )
            : null,
        errorWidget: (context, url, error) =>
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: AssetImage(
                        AssetsUtils.appPlaceHolderLogo,
                      ))),
            ),
      );
}
