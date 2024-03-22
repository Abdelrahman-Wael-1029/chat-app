import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../common/widgets/loading.dart';

class ShowImage extends StatelessWidget {
  String src;
  static const String route = '/showImage';

  ShowImage({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: IconButton(
         icon: Icon(Icons.close),
         onPressed: () {
           Navigator.pop(context);
         },
       ),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: src,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          placeholder: (context, url) => Loading(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      )
    );
  }
}
