import 'dart:io';

import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/models/message.dart';
import 'package:dartchat/models/user_presentation.dart';
import 'package:dartchat/services/storage_service/storage_repository.dart';
import 'package:flutter/foundation.dart';

class StorageServiceFakeImpl implements StorageRepository {
  @override
  Stream<List<UserPresentation>> fetchFirstUsers(
      {String userId, int maxLength}) async* {
    await Future.delayed(Duration(seconds: 1));
    //return fakeUsers;
  }

  @override
  Future<UserChat> fetchProfileUser([String userId]) async {
    return UserChat(
      userId: "4324324234",
      name: 'Hosain Mohamed',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatar1.jpg',
    );
  }

  @override
  Future<void> saveProfileUser(UserChat user) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> fetchFirstMessages({
      @required String userId,
      @required String friendId,
      @required int maxLength,
      @required String imgUrl,
      @required String thumbUrl,
      @required int thumbHeight,
  }) async* {
    await Future.delayed(Duration(milliseconds: 500));
    yield fakeMessages;
  }

  // Future<void> sendMessage(
  //     String message, String userId, String friendId) async {
  //   fakeMessages.add(Message(message: message, senderID: '0'));
  // }

  List<Message> fakeMessages = [];
  static List<UserChat> fakeUsers = [
    UserChat(
      userId: "4324324234",
      name: 'Rostyslav N',
      email: 'shs442222@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar4.png',
    ),
    UserChat(
      userId: "4324324235",
      name: 'Ahmed Nagy',
      email: 'hosain.m.abdellatif@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar2.png',
    ),
    UserChat(
      userId: "4324324236",
      name: 'Alaa Fathy',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar4.png',
    ),
    UserChat(
      userId: "4324324237",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
    UserChat(
      userId: "4324324238",
      name: 'Ahmed Nagy',
      email: 'hosain.m.abdellatif@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar2.png',
    ),
    UserChat(
      userId: "4324324239",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
    UserChat(
      userId: "4324324241",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
    UserChat(
      userId: "4324324242",
      name: 'Sara Adel',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar3.png',
    ),
    UserChat(
      userId: "4324324243",
      name: 'Muhammad Nader',
      email: 'shs442000@gmail.com',
      imageType: ImageType.assets,
      imgUrl: 'assets/images/avatars/avatar5.png',
    ),
  ];

  @override
  Future<UserChat> updateProfileNameAndImage(
      {String userId, String name, File photo, String imgUrl}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage({
    String message, 
    String userId, 
    String friendId, 
    String imgUrl,
    String thumbUrl,
    int thumbHeight,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> markMessageSeen(String userID, String friendID) {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> fetchNextMessages(
      {@required String userId,
      @required String friendId,
      @required int maxLength,
      @required int firstMessagesLength,
      @required String imgUrl,
      @required String thumbUrl,
      @required int thumbHeight,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<UserPresentation>> searchByName({String userId, String name}) {
    throw UnimplementedError();
  }
}
