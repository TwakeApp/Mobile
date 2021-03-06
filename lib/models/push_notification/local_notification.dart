import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'local_notification.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class LocalNotification {
  final LocalNotificationType type;

  final Map<String, dynamic> payload;

  const LocalNotification({required this.type, required this.payload});

  factory LocalNotification.fromJson({required Map<String, dynamic> json}) {
    return _$LocalNotificationFromJson(json);
  }

  factory LocalNotification.fromEncodedString({required String string}) {
    final Map<String, dynamic> json = jsonDecode(string);

    return LocalNotification.fromJson(json: json);
  }

  Map<String, dynamic> toJson() {
    return _$LocalNotificationToJson(this);
  }

  String get stringified => jsonEncode(this.toJson());
}

enum LocalNotificationType {
  @JsonValue('message')
  message,
  @JsonValue('file')
  file
}
