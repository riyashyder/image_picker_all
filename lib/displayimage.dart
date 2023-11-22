import 'package:flutter/material.dart';

import 'appdata.dart';
//import 'package:pageviewimagedisplay/appdata.dart';



class DisplayImage extends StatelessWidget {
  final Appdata appdata;

  const DisplayImage({super.key, required this.appdata});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(appdata.image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
