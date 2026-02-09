import 'package:flutter/material.dart';

class AppBorder {
  static final appBarBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.only(
      bottomLeft: Radius.circular(1),
      bottomRight: Radius.circular(1),
    ),
  );
  static final navBarBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    ),
  );

  static final BorderRadiusGeometry appBoxBorder = BorderRadius.circular(2);

  static final contactBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.only(
      bottomLeft: Radius.circular(5),
      bottomRight: Radius.circular(5),
      topRight: Radius.circular(5),
      topLeft: Radius.circular(5),
    ),
  );
}
