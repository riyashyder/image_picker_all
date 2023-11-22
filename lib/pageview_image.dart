import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'appdata.dart';
import 'displayimage.dart';
import 'indicator.dart';


class PageViewImage extends StatefulWidget {
  const PageViewImage({super.key});

  @override
  State<PageViewImage> createState() => _PageViewImageState();
}

class _PageViewImageState extends State<PageViewImage> {
  var selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Directory Images',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
            [PopupMenuItem(value: 1, child: Text('Share'))],
            onSelected: (value) {
              if (value == 1) {
                share();
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: 400,
              height: 400,
              child: PageView.builder(
                  onPageChanged: (index){
                    setState(() {
                      selectedindex=index;
                    });
                  },
                  itemCount: appdatalist.length,
                  itemBuilder: (context, index) {
                    return DisplayImage(appdata: appdatalist[index]);
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    appdatalist.length,
                        (index) => Indicator(
                        isActive: selectedindex == index ? true : false)),
              ],
            )
          ],
        ),
      ),
    );
  }

  share() async {
    ByteData imagebyte =
    await rootBundle.load(appdatalist[selectedindex].image);
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/download.jpg';
    File(path).writeAsBytesSync(imagebyte.buffer.asUint8List());
    await Share.shareFiles([path], text: 'image shared');
  }
}
