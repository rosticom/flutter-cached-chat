import 'dart:io';

import 'package:dartchat/models/message.dart';
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/models/user_presentation.dart';
import 'package:flutter/foundation.dart';

abstract class StorageRepository {
  Stream<List<UserPresentation>> fetchFirstUsers({
       @required String userId, 
       @required int maxLength
  });

  Stream<List<Message>> fetchFirstMessages({
      @required String userId,
      @required String friendId,
      @required int maxLength,
      @required String imgUrl,
      @required String thumbUrl,
      @required int thumbHeight,
  });

  Future<List<Message>> fetchNextMessages({
      @required String userId,
      @required String friendId,
      @required int maxLength, 
      @required int firstMessagesLength,
      @required String imgUrl,
      @required String thumbUrl,
      @required int thumbHeight,
  });

  Future<void> sendMessage({
      @required String message,
      @required String userId,
      @required String friendId,
      @required String imgUrl,
      @required String thumbUrl,
      @required int thumbHeight,
  });
      
  Future<UserChat> fetchProfileUser([String userID]);
  Future<void> saveProfileUser(UserChat user);
  Future<void> markMessageSeen(String userId, String friendId);
  Future<UserChat> updateProfileNameAndImage({
      @required String userId,
      @required String name,
      File photo,
      String imgUrl
  });
  Future<List<UserPresentation>> searchByName({
      @required String userId, 
      @required String name
  });
}
