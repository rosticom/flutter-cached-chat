
import 'dart:io';
import 'dart:typed_data';
import 'package:dartchat/models/message.dart';
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/utils/functions.dart';
import 'package:dartchat/view/messages/bloc/messages_bloc.dart';
import 'package:dartchat/view/messages/widgets/message_input.dart';
import 'package:dartchat/view/messages/widgets/message_item.dart';
import 'package:dartchat/view/register/bloc/account_bloc.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/widgets/progress_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as imgForDecode;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:cached_video_player/cached_video_player.dart';

class MessagesList extends StatefulWidget {
  final UserChat friend;
  MessagesList({
    @required this.friend,
  });

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  TextEditingController _textController;
  List<Message> messages;
  ScrollController _scrollController = ScrollController();
  bool noMoreMessages = false;
  File pickedImage;
  File pickedVideo;
  String imgUrl;
  String thumbUrl = "";
  int thumbHeight;
  String newNetworkImage = "";
  double progressUpload;
  dynamic boxMessages;
  dynamic boxImages;
  dynamic boxMediaKeys;
  dynamic boxThumbnails;
  dynamic boxThumbnailsHeight;
  List<dynamic> messagesList = [];
  List<dynamic> imagesList = [];
  List<dynamic> thumbnailList = [];
  List<dynamic> thumbHeightList = [];
  bool _initSuccess = false;
  String keyTempThumbnail = '';

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.addListener(() => _textListener() );
    _scrollController = ScrollController();
    _scrollController.addListener(() => _scrollListener());
    _initMessagesHive();
    super.initState();
  }

  void _textListener() {
    setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !noMoreMessages) {
          BlocProvider.of<MessagesBloc>(context).add(MoreMessagesFetched(
          _scrollController.position.pixels, messages.length));
    }
  }

  void _initMessagesHive() async {
    boxMessages = await Hive.openBox('messages-sender');
    boxImages = await Hive.openBox('images-urls');
    boxMediaKeys = await Hive.openBox('media-keys');
    boxThumbnails = await Hive.openBox('thumbnails');
    boxThumbnailsHeight = await Hive.openBox('thumbnails-height');
    List messagesList = [];
    List imagesList = [];
    List thumbnailList = [];
    List thumbHeightList = [];
    String keyUserChat = widget.friend.userId+'_'+widget.friend.userId;
    messagesList = await boxMessages.get(keyUserChat);
    imagesList = await boxImages.get(keyUserChat);
    thumbnailList = await boxThumbnails.get(keyUserChat);
    thumbHeightList = await boxThumbnailsHeight.get(keyUserChat);
    List messages = [];
      if (messagesList != null) {
        for (int i = 0; i < messagesList.length; i++) {
          Message message = new Message(
            senderId: messagesList[i].senderId,
            message: messagesList[i].message,
            time: messagesList[i].time,
            imgUrl: imagesList[i].imgUrl,
            thumbUrl: thumbnailList[i].thumbUrl,
            thumbHeight: thumbHeightList[i].thumbHeight,
          );
          messages.add(message);
        }
      }
      setState(() { _initSuccess = true; });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    boxMessages.close();
    boxImages.close();
    boxThumbnails.close(); 
    boxThumbnailsHeight.close(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String friendSender = widget.friend.userId;
    String userId = BlocProvider.of<AccountBloc>(context).userId;
    return BlocConsumer<MessagesBloc, MessagesState>(
        listener: (context, state) {
      _mapStateToActions(state);
    }, builder: (_, state) {
      if ((messages!=null && _initSuccess == true)) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  messages.length < 1
                    ? Center(
                        child: Text("No messages yet ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: kBackgroundButtonColor,
                      )))
                    : ListView.builder(
                        // physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 5),
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final message = messages[index];
                          String indexTime = messages[index].time;
                          String senderKey = '$userId'+'_$friendSender'+'_$indexTime';
                          String imageKey;
                          try {
                            imageKey = boxMediaKeys.get(senderKey);
                          } catch (_) { imageKey = ''; }
                          return MessageItem(
                            // showFriendImage: _showFriendImage(message, index),
                                  friend: widget.friend,
                                 message: message.message,
                                senderId: message.senderId,
                                  imgUrl: message.imgUrl,
                                  imgKey: imageKey,
                                thumbUrl: message.thumbUrl == "" || message.thumbUrl == null 
                                          ? null 
                                          : message.thumbUrl,
                             thumbHeight: message.thumbHeight,
                          );
                        }),
                            
              state is MoreMessagesLoading
                ? Padding(
                    padding: EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.topCenter,
                            child: const CircleProgress(radius: 0.023)),
                  ): SizedBox.shrink()
                ],
              ),
            ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.5, color: chatBackground)))),
          Container(        
            color: lightestColor, 
            child: Row(
              children: <Widget>[
                BlocProvider.of<MessagesBloc>(context, listen: true).keyTempThumbnail == null 
                ? 
                new Container(
                  color: lightestColor,
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(
                        Icons.photo_camera,
                        color: darkColor,
                      ),
                      onPressed: () async {
                        _getImage();
                      }),
                ) : SizedBox(width: 20),
                new Flexible(
                  child: MessageInput(controller: _textController),
                ),
                BlocProvider.of<MessagesBloc>(context).keyTempThumbnail == null &&
                  _textController.text == ""
                ? 
                Container(
                  color: lightestColor,
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(
                        Icons.videocam,
                        color: darkColor,
                      ),
                      onPressed: () async {
                        _getVideo();
                      })):
                  Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkResponse(
                    child: Icon(
                      Icons.send,
                      color: sendButtonColor,
                      size: 23,
                    ),
                    onTap: () async {
                      if (_textController.text.trim().isNotEmpty) {
                          BlocProvider.of<MessagesBloc>(context).add(
                            MessageSent(
                              message: _textController.text, 
                              friendId: widget.friend.userId, 
                              imgUrl: imgUrl,
                              thumbUrl: thumbUrl,
                              thumbHeight: thumbHeight,
                            )
                          );
                      }
                      imgUrl = "";
                    },
                  ),
                ),
              ],
            ),
          )
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }

  bool _showFriendImage(Message message, int index) {
    if (message.senderId == widget.friend.userId) {
      if (index == 0) {
        return true;
      } else if (index > 0) {
        String nextSender = messages[index - 1].senderId;
        if (nextSender == widget.friend.userId) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }

  void _mapStateToActions(MessagesState state) {
    if (Functions.modalIsShown) {
      Navigator.pop(context);
      Functions.modalIsShown = false;
    }

    if (state is MessageSentFailure) {
      Functions.showBottomMessage(context, state.failure.code);
    } else if (state is MessagesLoadFailed) {
      Functions.showBottomMessage(context, state.failure.code);
    } else if (state is MessagesLoadSucceed) {
      if (_scrollController.hasClients) {
        // _scrollController?.jumpTo(state.scrollposition);
      }
      if (state.noMoreMessages != null) {
        noMoreMessages = state.noMoreMessages;
      }
      setState(() {  });
      messages = state.messages;
      _messagesCash();
      _textController.clear();
    } else if (state is MoreMessagesFailed) {
      Functions.showBottomMessage(context, state.failure.code);
    }
  }

  void _messagesCash() async {
      messagesList = [];
      imagesList = [];
      thumbnailList = [];
      thumbHeightList = [];
       
    for (int i=0; i<messages.length; i++) {
        messagesList.add(messages[i].message);
        imagesList.add(messages[i].imgUrl);
        thumbnailList.add(messages[i].thumbUrl);
        thumbHeightList.add(messages[i].thumbHeight);
    }
      String userId = BlocProvider.of<AccountBloc>(context).userId;
      String friendSender = widget.friend.userId;

      try {
        await boxMessages.put(userId, messagesList);
      } catch (e) { print(e); }
      try {  
        await boxImages.put(userId, imagesList);
      } catch (e) { print(e); }
      try {
        await boxThumbnailsHeight.put(userId, thumbnailList);
      } catch (e) { print(e); }
      try {  
        await boxImages.put(userId, thumbHeightList);
      } catch (e) { print(e); }

      String indexKey = messages[0].time;

      if (messages[0].imgUrl != "" &&
          messages[0].imgUrl != null) {
            print('IMG URL - messages[0].imgUrl ===============================');
            print(messages[0].imgUrl);
            String senderKey = '$userId'+'_$friendSender'+'_$indexKey';
            String imageKey;
            print(senderKey);
            try { 
              imageKey = boxMediaKeys.get(senderKey);
              // BlocProvider.of<MessagesBloc>(context).keyTempImg = imageKey;
              print('already have cache key: $imageKey');
            }
            catch (err) { imageKey = null; }

            if (imageKey == null) {
              newNetworkImage = messages[0].imgUrl;
              File file = await DefaultCacheManager().getSingleFile(newNetworkImage);
              String fileUrlString = file.uri.path;
              try {  
                await boxMediaKeys.put(senderKey, fileUrlString);
                imageKey = boxMediaKeys.get(senderKey);
                BlocProvider.of<MessagesBloc>(context).keyTempImg = imageKey;
                print('create new key: $imageKey');
                print('sender-key: $senderKey');
              } 
              catch(e) { 
                print(e); 
              }
          }
      } else { 
        print('not need cache key (text message)');
      }
   setState(() {  });
  }

  Future<void> _getVideo() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
    print(pickedFile.path); 
    String textMessage;
    if (pickedFile != null) { 
      setState(() { BlocProvider.of<MessagesBloc>(context).isUpload = true; });
      _textController.clear();
      pickedVideo = File(pickedFile.path);
      int timestamp = new DateTime.now().millisecondsSinceEpoch;
     
      CachedVideoPlayerController videoController = CachedVideoPlayerController.file(pickedVideo);
      videoController.initialize().then((_) {
        Duration videoDuration = videoController.value.duration;
        textMessage = "Video - ${_printDuration(videoDuration)}";
        print(textMessage);
      });
      final uint8List = await VideoThumbnail.thumbnailData(
        video: pickedVideo.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 150, 
        quality: 50,
      );
      setState(() { BlocProvider.of<MessagesBloc>(context).keyTempThumbnail = uint8List; });

          Message temporaryMessage = new Message(
            senderId: BlocProvider.of<MessagesBloc>(context).userId,
            message: '',
            time: '1111111111101',
            imgUrl: '',
            thumbUrl: 'video',
            thumbHeight: 250,
          ); 
          messages.insert(0, temporaryMessage);

           String videoUrl = await _uploadVideo(widget.friend.userId, pickedVideo, timestamp, true);
           print(videoUrl);
     
            BlocProvider.of<MessagesBloc>(context).add(
            MessageSent(
              message: textMessage, 
              friendId: widget.friend.userId, 
              imgUrl: videoUrl,
              thumbUrl: thumbUrl,
              thumbHeight: 00000011111
          )); 
     }   
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String durationInHours = twoDigits(duration.inHours);
    String stringDuration = "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    if (durationInHours == "00") { stringDuration = "$twoDigitMinutes:$twoDigitSeconds"; }
    if (twoDigitMinutes[0] == "0") { stringDuration = stringDuration.replaceFirst("0", ""); }
    return stringDuration;
  }

  Future<void> _getImage() async {
    try {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
          String textMessage = _textController.text.trim();
          _textController.clear();
          int timestamp = new DateTime.now().millisecondsSinceEpoch;
          pickedImage = File(pickedFile.path);
          var thumbnail = decodingImage(pickedFile);
          
          final Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path + '/temporary-thumbnail.png';
          File(tempPath).writeAsBytesSync(imgForDecode.encodePng(thumbnail));
  
          int thumbHeight = thumbnail.height * 2;
          Uint8List bytes = pickedImage.readAsBytesSync();
          BlocProvider.of<MessagesBloc>(context).keyTempThumbnail = bytes;

          keyTempThumbnail = tempDir.path + '/temporary-thumbnail250.png';
          print("KEY TEMPORARY THUMBNAIL: " + keyTempThumbnail);

          Message temporaryMessage = new Message(
            senderId: BlocProvider.of<MessagesBloc>(context).userId,
            message: textMessage,
            time: '1111111111110',
            imgUrl: '',
            thumbUrl: keyTempThumbnail,
            thumbHeight: thumbHeight,
          ); 
          messages.insert(0, temporaryMessage);

          File thumbFile = File(tempPath);
        
          String thumbUrl = await _uploadImageThumbnail(widget.friend.userId, thumbFile, timestamp, false);
          print('THUMBNAIL URL:');
          print(thumbUrl);
          String imageUrl = await _uploadImage(widget.friend.userId, pickedImage, timestamp, false);

          BlocProvider.of<MessagesBloc>(context).add(
            MessageSent(
              message: textMessage, 
              friendId: widget.friend.userId, 
              imgUrl: imageUrl,
              thumbUrl: thumbUrl,
              thumbHeight: thumbHeight
          )); 
      }   
    } catch (e) { print('image pickup catch error: '+'$e'); }
  }

  decodingImage(pickedFile) {
      imgForDecode.Image image = imgForDecode.decodeJpg(File(pickedFile.path).readAsBytesSync());
      imgForDecode.Image thumbnail = imgForDecode.copyResize(image, width: 125);
    return thumbnail;
  }

  Future<String> _uploadVideo(
    String userId, 
    File video, 
    int timestamp, 
    [bool haveNetworkImage = true])
  async {
      Reference storageReference = FirebaseStorage.instance.ref().child(userId + "_$timestamp");
        final uploadTask = storageReference.putFile(video);
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progressUpload = uploadTask.snapshot.bytesTransferred.toDouble() /
              uploadTask.snapshot.totalBytes.toDouble();
            BlocProvider.of<MessagesBloc>(context).progressUpload = progressUpload; });
        }).onError((e) { 
          print(e);
           setState(() {
             BlocProvider.of<MessagesBloc>(context).progressUpload = 0;
           }); 
        });
        String videoNew = await uploadTask.then((complete) => complete.ref.getDownloadURL());
      return videoNew;
  }

  Future<String> _uploadImage(
    String userId, File photo, int timestamp, [bool haveNetworkImage = false]) async {
      Reference storageReference = FirebaseStorage.instance.ref().child(userId + "_$timestamp");
      final uploadTask = storageReference.putFile(photo);
      uploadTask.snapshotEvents.listen((event) {
          progressUpload = uploadTask.snapshot.bytesTransferred.toDouble() /
            uploadTask.snapshot.totalBytes.toDouble() / 2;
          BlocProvider.of<MessagesBloc>(context).progressUpload = progressUpload;  
      }).onError((e) { 
        print(e); 
        setState(() { BlocProvider.of<MessagesBloc>(context).progressUpload = 0; });
      });
      String imageNew = await uploadTask.then((complete) => complete.ref.getDownloadURL());
    return imageNew;
  }

  Future<String> _uploadImageThumbnail(
    String userId, File file, int timestamp, [bool haveNetworkImage = false]) async {
      Reference storageReference = 
        FirebaseStorage.instance.ref().child(userId + "_$timestamp" + "_thumbnail");
         // if (haveNetworkImage) await storageReference.delete();
        final uploadTask = storageReference.putFile(file);
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progressUpload = uploadTask.snapshot.bytesTransferred.toDouble() /
              uploadTask.snapshot.totalBytes.toDouble() / 2 + 0.5;
            BlocProvider.of<MessagesBloc>(context).progressUpload = progressUpload;    
          });
        })
        .onError((e) { 
          print(e);
          setState(() { BlocProvider.of<MessagesBloc>(context).progressUpload = 0; });
        });
        String thumbNew = await uploadTask.then((complete) => complete.ref.getDownloadURL());
    return thumbNew;
  }
}