import 'package:json_annotation/json_annotation.dart';
import 'package:twake/models/collection_item.dart';

// part 'base_channel.g.dart';

abstract class BaseChannel extends CollectionItem {
  @JsonKey(required: true, nullable: false)
  String id;

  @JsonKey(required: true)
  String name;

  String icon;

  String description;

  @JsonKey(required: true, name: 'members_count')
  int membersCount;

  @JsonKey(required: true, name: 'last_activity')
  int lastActivity;

  @JsonKey(required: true, name: 'messages_total')
  int messagesTotal;

  @JsonKey(required: true, name: 'messages_unread')
  int messagesUnread;

  @JsonKey(name: 'is_selected', defaultValue: 0)
  int isSelected;

  BaseChannel({
    this.id,
  }) : super(id);
}
