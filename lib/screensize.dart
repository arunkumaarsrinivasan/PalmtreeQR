import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenwidth;
  static double? screenheight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;
  
  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenwidth = _mediaQueryData?.size.width;
    screenheight = _mediaQueryData?.size.height;
    blockSizeHorizontal = screenwidth! / 100;
    blockSizeVertical = screenheight! / 100;
    _safeAreaHorizontal = _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical = _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenwidth! - _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenheight! - _safeAreaVertical!) / 100;
  }
}

var x = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
          
        )
  ),
  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
);
