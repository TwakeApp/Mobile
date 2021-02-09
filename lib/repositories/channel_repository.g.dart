// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelRepository _$ChannelRepositoryFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['company_id', 'workspace_id', 'name']);
  return ChannelRepository(
    json['company_id'] as String,
    json['workspace_id'] as String,
    json['name'] as String,
    visibility: json['visibility'] as String ?? 'public',
    icon: json['icon'] as String,
    description: json['description'] as String,
    channelGroup: json['channel_group'] as String,
    def: json['default'] as bool,
    members: (json['members'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ChannelRepositoryToJson(ChannelRepository instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'workspace_id': instance.workspaceId,
      'name': instance.name,
      'visibility': instance.visibility,
      'icon': instance.icon,
      'description': instance.description,
      'channel_group': instance.channelGroup,
      'default': instance.def,
      'members': instance.members,
    };
