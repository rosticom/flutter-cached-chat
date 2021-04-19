import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartchat/models/message.dart';
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/services/authentication_service/authentication_repository.dart';
import 'package:dartchat/services/storage_service/storage_repository.dart';
import 'package:dartchat/utils/failure.dart';
import 'package:dartchat/utils/functions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final StorageRepository storageRepository;
  final AuthenticationRepository authRepository;
  final int firstMessagesLength = 50;
  final int moreMessagesLength = 50;
  StreamSubscription<List<Message>> _streamSubscription;
  List<Message> allMessages = [];
  String friendId;
  String userId;
  String imgUrl;
  String thumbUrl;
  int thumbHeight;
  bool isUpload = false;
  int uploadThumbnailHeight = 0;
  double progressUpload = 0;
  String uploadedThumbnail = "";
  dynamic keyTempThumbnail;
  dynamic keyTempImg;
  MessagesBloc(
      {@required this.authRepository, @required this.storageRepository})
      : super(MessagesInitial());

  @override
  Stream<MessagesState> mapEventToState(
    MessagesEvent event,
  ) async* {
    if (userId == null) {
      userId = await authRepository.getUserID();
    }
    if (event is MessagesStartFetching) {
      yield* handleMessagesStartFetchingEvent(event);
    } else if (event is NewMessagesFetched) {
      yield MessagesLoadSucceed(event.messages, 0);
    } else if (event is MoreMessagesFetched) {
      yield* handleMoreMessagesFetchedEvent(event);
    } else if (event is MessageSent) {
      yield* handleMessageSentEvent(event);
    }
  }

  Stream<MessagesState> handleMessagesStartFetchingEvent(
      MessagesStartFetching event) async* {
    yield MessagesLoading();
    // if (!await Functions.getNetworkStatus(duration: Duration(milliseconds: 100))) {
    //   yield MessagesLoadFailed(NetworkException());
    // } else {
      try {
        friendId = event.user.userId;
        _streamSubscription?.cancel();
        final messagesStream = storageRepository.fetchFirstMessages(
            userId: userId, 
            friendId: friendId, 
            imgUrl: '',
            thumbUrl: thumbUrl,
            thumbHeight: thumbHeight,
            maxLength: firstMessagesLength
        );
        _streamSubscription = messagesStream.listen((messages) async {
          messages ??= [];
          print('messages.length: '+'${messages.length}');
          if (keyTempThumbnail != null) {
            allMessages[0]=messages[0];
        }
        if (keyTempThumbnail == null) {
          if (allMessages.length < 1 || allMessages.length < messages.length) {
            allMessages = messages;
          } else {
            allMessages = messages + allMessages.sublist(messages.length - 1);
          }
        } else { isUpload = false; keyTempThumbnail = null; }
          if (allMessages.length > 0 && allMessages[0].senderId != userId) {
            storageRepository.markMessageSeen(userId, event.user.userId);
          }
          add(NewMessagesFetched(allMessages));
         
        });
      } on Failure catch (failure) {
        yield MessagesLoadFailed(failure);
      }
    // }
  }

  Stream<MessagesState> handleMoreMessagesFetchedEvent(
      MoreMessagesFetched event) async* {
    yield MoreMessagesLoading();
    if (!await Functions.getNetworkStatus()) {
      yield MoreMessagesFailed(NetworkException());
    } else {
      try {
        final nextMessages = await storageRepository.fetchNextMessages(
          userId: userId,
          friendId: friendId,
          imgUrl: imgUrl,
          thumbUrl: thumbUrl,
          thumbHeight: thumbHeight,
          maxLength: moreMessagesLength,
          firstMessagesLength: event.messagesLength,
        );
        allMessages.addAll(nextMessages);

        if (nextMessages.length < moreMessagesLength) {
          yield MessagesLoadSucceed(allMessages, event.scrollposition, true);
        } else {
          yield MessagesLoadSucceed(allMessages, event.scrollposition, false);
        }
      } on Failure catch (failure) {
        yield MoreMessagesFailed(failure);
      }
    }
  }

  Stream<MessagesState> handleMessageSentEvent(MessageSent event) async* {
    yield MessagesCheckInternet();
    if (!await Functions.getNetworkStatus(duration: Duration.zero)) {
      yield MessageSentFailure(NetworkException());
    } else {
      try {
        await storageRepository.sendMessage(
            message: event.message, 
            userId: userId, 
            friendId: event.friendId, 
            imgUrl: event.imgUrl,
            thumbUrl: event.thumbUrl,
            thumbHeight: event.thumbHeight);
      } on Failure catch (failure) {
        yield MessageSentFailure(failure);
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
