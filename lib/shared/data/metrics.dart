import 'package:material_ui/material_ui.dart';

abstract final class Space {
  static const double hair = 2;
  static const double tight = 4;
  static const double small = 8;
  static const double snug = 12;
  static const double medium = 16;
  static const double page = 20;
  static const double large = 24;
  static const double section = 32;
}

const double toolbarClearance = 88;

abstract final class Corner {
  static const double small = 4;
  static const double medium = 6;
  static const double large = 8;

  static const BorderRadius cards = BorderRadius.all(Radius.circular(small));
  static const BorderRadius panels = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius toolbar = BorderRadius.all(Radius.circular(large));
}

abstract final class Layout {
  static const double compact = 600;
  static const double medium = 840;
  static const double column = 960;

  static double gutterFor(double width) {
    if (width >= column + Space.section * 2) return (width - column) / 2;
    if (width >= medium) return Space.section;
    if (width >= compact) return Space.large;
    return Space.medium;
  }

  static double gutterOf(BuildContext context) =>
      gutterFor(MediaQuery.sizeOf(context).width);

  static EdgeInsets pageOf(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: gutterOf(context));

  static EdgeInsets textOf(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: gutterOf(context) + Space.medium);
}
