import 'package:flutter/material.dart';
import 'package:twake/models/badge/badge.dart';
import 'package:twake/widgets/common/badges.dart';
import 'package:twake/widgets/common/channel_thumbnail.dart';
import 'package:twake/widgets/common/rounded_image.dart';

typedef OnHomeChannelTileClick = void Function();

class HomeChannelTile extends StatelessWidget {
  final String? title;
  final String? name;
  final String? content;
  final String? imageUrl;
  final int? dateTime;
  final OnHomeChannelTileClick? onHomeChannelTileClick;
  final String? channelid;

  const HomeChannelTile(
      {this.title,
      this.name,
      this.content,
      this.imageUrl,
      this.dateTime,
      this.onHomeChannelTileClick,
      this.channelid})
      : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onHomeChannelTileClick,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ChannelThumbnail(
                      icon: imageUrl ?? '',
                      width: 54,
                      height: 54,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 11,
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(title ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ))),
                        Text(
                          '', // todo parse datetime
                          style: TextStyle(
                            color: Color(0xffc2c6cc),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            name ?? 'This channel is empty',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Color(0xb2000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Spacer(),
                          BadgesCount(BadgeType.channel, channelid!)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        content ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0x7f000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
