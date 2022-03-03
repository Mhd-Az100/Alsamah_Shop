import 'package:flutter/material.dart';
import 'package:waslcom/core/repos/static_views_repo.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';

class ContactUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          child: SharedCachedNetworkImage.getCachedNetworkImage(
              size: MediaQuery.of(context).size,
              imageUrl: StaticRepos.Contact_Us,
              forProductDetails: true,

              showPlaceHolder: false),
        ),
      ],
    ));
  }
}
