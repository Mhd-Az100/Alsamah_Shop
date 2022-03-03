import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinearGradientButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final TextStyle titleStyle;
  final List<Color> colorsList;
  final double borderRaduis;

  const LinearGradientButton(
      {Key key,
      this.onTap,
      @required this.title,
      this.colorsList,
      this.titleStyle,
      this.borderRaduis = 6})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(
        onPressed: onTap,
        padding: EdgeInsets.all(0),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRaduis),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colorsList ??
                  [
                    Color(0xffff5f6d),
                    Color(0xffff5f6d),
                    Color(0xffffc371),
                  ],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints:
                BoxConstraints(maxWidth: double.infinity, minHeight: 50),
            child: Text(
              title ?? "",
              style: titleStyle ??
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceOrderGradientButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final TextStyle titleStyle;
  final List<Color> colorsList;

  const PlaceOrderGradientButton(
      {Key key,
      this.onTap,
      @required this.title,
      this.colorsList,
      this.titleStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(
        onPressed: onTap,
        padding: EdgeInsets.all(0),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20), topLeft: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colorsList ??
                  [
                    Color(0xffff5f6d),
                    Color(0xffff5f6d),
                    Color(0xffffc371),
                  ],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints:
                BoxConstraints(maxWidth: double.infinity, minHeight: 50),
            child: Text(
              title ?? "",
              style: titleStyle ??
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
