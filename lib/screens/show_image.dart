import 'package:flutter/material.dart';

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
        child: Image.network(src,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        )
      )
    );
  }
}
