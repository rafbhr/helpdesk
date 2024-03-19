
import 'package:flutter/material.dart';

class NavbarKey{
  NavbarKey._();

  static final _key = GlobalKey();

  static GlobalKey getKey() => _key;
}