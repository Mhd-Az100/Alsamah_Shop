import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waslcom/core/repos/static_views_repo.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';
import 'package:waslcom/ui/shared_widgets/cached_image_widget.dart';

class TermsConditionsView extends StatefulWidget {
  @override
  _TermsConditionsViewState createState() => _TermsConditionsViewState();
}

class _TermsConditionsViewState extends State<TermsConditionsView> {
  int _viewIndex = 1;

  void setViewIndex() {
    if (_viewIndex == 1) {
      setState(() {
        _viewIndex = 2;
      });
    } else {
      setState(() {
        _viewIndex = 1;
      });
    }
  }

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
              imageUrl:
                  _viewIndex == 1 ? StaticRepos.Terms_1 : StaticRepos.Terms_2,
              forProductDetails: true,
              showPlaceHolder: false),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
                icon: Icon(
                  _viewIndex == 1
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  size: size.longestSide / 16,
                  color: AppColors.orangeColor.withOpacity(0.9),
                ),
                onPressed: setViewIndex),
          ),
        ),
      ],
    ));
  }
}
