
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class CachedVideo extends StatefulWidget {
  CachedVideo({Key key, this.title}) : super(key: key);
  final String title;

  CachedVideoState cachedVideoState = new CachedVideoState();
   @override
   CachedVideoState createState() => CachedVideoState();
    void playVideoButton(){
      cachedVideoState.playVideoButton();
    }

  // @override
  // _CachedVideoState createState() => _CachedVideoState();
}

class CachedVideoState extends State<CachedVideo> {
  CachedVideoPlayerController controller;
  bool turnVideoPlayer = false;
  GlobalKey<CachedVideoState> myKey = GlobalKey();
  @override
  void initState() {
    controller =  CachedVideoPlayerController.network(widget.title);
    controller.initialize().then((_) {
      setState(() {});
        controller.play();
    });
    super.initState();
  }

  void playVideoButton() {
    setState(() { 
      controller.pause(); 
    });
  }

  play() {
    setState(() { 
      controller.pause(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<CachedVideoState> _myKey = GlobalKey();
    return Center(
          child: controller.value != null && controller.value.initialized
              ? AspectRatio(
                  child: CachedVideoPlayer(controller),
                  aspectRatio: controller.value.aspectRatio,
                )
              : Center(
                  child: CircularProgressIndicator(),
          ));
  }

  pause() {
    try { controller.pause(); }
    catch (e) { print('catch: $e'); }
    setState(() {
      print('state');
    });
  }

}