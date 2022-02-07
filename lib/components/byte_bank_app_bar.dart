import 'package:flutter/material.dart';

class ByteBankAppBar extends AppBar {
  ByteBankAppBar({required BuildContext context, required String title})
      : super(
          title: Text(title),
          backgroundColor: Theme.of(context).primaryColor,
        );
}
