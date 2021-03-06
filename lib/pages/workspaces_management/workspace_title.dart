import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twake/widgets/common/channel_thumbnail.dart';
import 'package:twake/widgets/common/rounded_image.dart';

typedef OnWorkspaceTileTap = void Function();

class WorkspaceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final bool selected;
  final OnWorkspaceTileTap? onTap;

  const WorkspaceTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.selected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(width: 16.0),
                // ChannelThumbnail(icon: image),
                RoundedImage(
                  width: 56,
                  height: 56,
                  borderRadius: 16.0,
                  imageUrl: image,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff949494),
                          ),
                        ),
                    ],
                  ),
                ),
                if (selected)
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Color(0xff3840F7),
                  ),
                SizedBox(width: 19.0),
              ],
            ),
            SizedBox(height: 8.0),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: Color(0xfff4f4f4),
            ),
          ],
        ),
      ),
    );
  }
}
