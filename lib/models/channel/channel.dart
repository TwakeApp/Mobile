import 'package:json_annotation/json_annotation.dart';
import 'package:twake/models/base_model/base_model.dart';
import 'package:twake/models/channel/channel_visibility.dart';
import 'package:twake/utils/json.dart' as jsn;

part 'channel.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Channel extends BaseModel {
  static const COMPOSITE_FIELDS = ['members', 'permissions'];

  final String id;

  final String name;

  final String? icon;

  final String? description;

  final String companyId;

  final String workspaceId;

  @JsonKey(defaultValue: 1)
  final int membersCount;

  final List<String> members;

  final ChannelVisibility visibility;

  final int lastActivity;

  @JsonKey(defaultValue: 0)
  final int userLastAccess;

  final String? draft;

  List<String> permissions;

  bool get hasUnread => userLastAccess < lastActivity;

<<<<<<< HEAD
  Channel(
      {required this.id,
      required this.name,
      this.icon,
      this.description,
      required this.companyId,
      required this.workspaceId,
      this.membersCount: 1,
      required this.members,
      required this.visibility,
      required this.lastActivity,
      this.userLastAccess: 0,
      this.draft,
      required this.permissions});
=======
  int get hash {
    final int hash =
        name.hashCode + icon.hashCode + lastActivity + members.length;
    return hash;
  }

  int get membersCount => members.length;

  Channel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    required this.companyId,
    required this.workspaceId,
    this.lastMessage,
    required this.members,
    required this.visibility,
    required this.lastActivity,
    this.userLastAccess: 0,
    this.draft,
    required this.permissions,
  });
>>>>>>> 5500978872b4ba8f1e5a80ee65f07b98f38a378a

  factory Channel.fromJson({
    required Map<String, dynamic> json,
    bool jsonify: true,
  }) {
    // message retrieved from sqlite database will have
    // it's composite fields json string encoded, so there's a
    // need to decode them back
    if (jsonify) {
      json = jsn.jsonify(json: json, keys: COMPOSITE_FIELDS);
    }
    return _$ChannelFromJson(json);
  }

  @override
  Map<String, dynamic> toJson({stringify: true}) {
    var json = _$ChannelToJson(this);
    // message that is to be stored to sqlite database should have
    // it's composite fields json string encoded, because sqlite doesn't support
    // non primitive data types, so we need to encode those fields
    if (stringify) {
      json = jsn.stringify(json: json, keys: COMPOSITE_FIELDS);
    }
    return json;
  }
}
