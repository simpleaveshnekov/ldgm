import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularImageCover extends StatefulWidget {
  final Color backgroundColor;
  final String imageUrl;
  final Icon icon;
  CircularImageCover({this.backgroundColor, this.imageUrl, this.icon}) : super();

  @override
  _CircularImageCoverState createState() => _CircularImageCoverState(backgroundColor: backgroundColor, imageUrl: imageUrl, icon: icon);
}

class _CircularImageCoverState extends State<CircularImageCover> {
  Color backgroundColor;
  String imageUrl;
  Icon icon;
  _CircularImageCoverState({this.backgroundColor, this.imageUrl, this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Colors.white,
      child: Center(
        child: imageUrl != null
            ? Padding(
                padding: const EdgeInsetsDirectional.all(12.0),
                child: SvgPicture.asset(
                  imageUrl,
                  height: 100,
                ),
              )
            : icon,
      ),
    );
  }
}
