import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waslcom/ui/shared_files/app_colors.dart';

class CustomTextWidget extends StatelessWidget {
  final String labelText;
  final Function onChange;
  final Function onSubmit;
  final Function validator;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle inputTextStyle;
  final TextStyle labelTextStyle;
  final bool secureText;
  final int maxLines;
  final int maxLength;
  final bool noBorders;
  final String noBorderHintText;
  final bool autoFocus;
  final TextAlign textAlign;
  final Widget prefixWidget;
  final double textSize;
  final List<TextInputFormatter> textFormatter;

  const CustomTextWidget({
    Key key,
    @required this.labelText,
    @required this.controller,
    this.onChange,
    this.onSubmit,
    this.validator,
    this.keyBoardType,
    this.textInputAction,
    this.padding,
    this.margin,
    this.inputTextStyle,
    this.labelTextStyle,
    this.secureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.noBorders = false,
    this.noBorderHintText,
    this.autoFocus = false,
    this.prefixWidget,
    this.textAlign,
    this.textFormatter,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: padding ?? EdgeInsets.all(15.5),
      margin: margin,
      child: TextFormField(
        controller: controller,
        onChanged: onChange,
        textAlign: textAlign ?? TextAlign.end,
        inputFormatters: textFormatter,
        onSaved: onSubmit,
        validator: validator,
        keyboardType: keyBoardType,
        textInputAction: textInputAction,
        style: inputTextStyle,
        cursorColor: Colors.grey.shade500,
        cursorHeight: 30,
        autofocus: autoFocus,
        decoration: noBorders
            ? InputDecoration.collapsed(hintText: noBorderHintText ?? "")
            : InputDecoration(
                labelText: labelText,
                labelStyle: labelTextStyle ??
                    GoogleFonts.cairo(
                        fontWeight: FontWeight.w300,
                        fontSize: textSize ?? 22,
                        color: Colors.grey.shade500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.blue300Color.withOpacity(0.5),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.redColor,
                    )),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.redColor,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.blue300Color,
                    )),
                prefix: prefixWidget != null
                    ? Container(width: size.width * 0.25, child: prefixWidget)
                    : null),
        obscureText: secureText,
        maxLines: maxLines,
        maxLength: maxLength,
      ),
    );
  }
}

class SecondCustomTextWidget extends StatelessWidget {
  final String labelText;
  final Function onChange;
  final Function onSubmit;
  final Function validator;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle inputTextStyle;
  final Color labelTextColor;
  final bool secureText;
  final int maxLines;
  final int maxLength;
  final bool noBorders;
  final String noBorderHintText;
  final bool autoFocus;
  final TextAlign textAlign;
  final Widget prefixWidget;
  final double textSize;
  final List<TextInputFormatter> textFormatter;

  const SecondCustomTextWidget({
    Key key,
    @required this.labelText,
    this.controller,
    this.onChange,
    this.onSubmit,
    this.validator,
    this.keyBoardType,
    this.textInputAction,
    this.padding,
    this.margin,
    this.inputTextStyle,
    this.labelTextColor,
    this.secureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.noBorders = false,
    this.noBorderHintText,
    this.autoFocus = false,
    this.prefixWidget,
    this.textAlign,
    this.textFormatter,
    this.textSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 14,
          ).copyWith(bottom: 10),
      child: Column(
        children: [
          Text(
            labelText,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
                fontWeight: FontWeight.w500,
                fontSize: textSize ?? 18,
                color: labelTextColor ?? Colors.grey.shade700),
          ),
          TextFormField(
            controller: controller,
            onChanged: onChange,
            textAlign: textAlign ?? TextAlign.end,
            inputFormatters: textFormatter,
            onSaved: onSubmit,
            validator: validator,
            keyboardType: keyBoardType,
            textInputAction: textInputAction,
            style: inputTextStyle,
            cursorColor: Colors.grey.shade500,
            cursorHeight: 30,
            autofocus: autoFocus,
            obscureText: secureText,
            maxLines: maxLines,
            maxLength: maxLength,
          )
        ],
      ),
    );
  }
}
