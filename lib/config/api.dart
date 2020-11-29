import 'package:sprintf/sprintf.dart';

class TwakeApiConfig {
  static const String _HOST = 'http://purecode.ru:3123';
  static const int _MESSAGES_PER_PAGE = 50;
  static const String _authorize = '/authorize';
  static const String _usersCurrentGet = '/users/current/get';
  static const String _workspaceChannels = '/workspace/%s/channels';
  static const String _channelMessages = '/channels/%s/messages';
  static const String _tokenProlong = '/authorization/prolong';
  static const String _directMessages = '/company/%s/direct';

  static Map<String, String> authHeader(token) {
    return {
      'Authorization': 'Bearer $token',
    };
  }

  static String get authorizeMethod {
    return _HOST + _authorize;
  }

  static String get currentProfileMethod {
    return _HOST + _usersCurrentGet + '?timezoneoffset=3';
  }

  static String workspaceChannelsMethod(String id) {
    return _HOST + sprintf(_workspaceChannels, [id]);
  }

  static String channelMessagesMethod(String channelId,
      {String beforeId, int limit, bool isPost: false}) {
    var url = _HOST + sprintf(_channelMessages, [channelId]) + '?';
    if (beforeId != null) {
      url = url + 'before=$beforeId&';
    }
    if (!isPost) {
      url = url + 'limit=${limit ?? _MESSAGES_PER_PAGE}&';
    }

    return url;
  }

  static String directMessagesMethod(String companyId) {
    return _HOST + sprintf(_directMessages, [companyId]);
  }

  /// Method for getting url, in order to prolong JWToken
  static String get tokenProlongMethod {
    return _HOST + _tokenProlong;
  }
}
