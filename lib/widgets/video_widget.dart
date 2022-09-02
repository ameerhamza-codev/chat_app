import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoWidget extends StatefulWidget {

  final bool play ;
  final String url;


  VideoWidget(this.play, this.url);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? videoPlayerController ;
  Future<void>? _initializeVideoPlayerFuture;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });

    _chewieController =  ChewieController(

      videoPlayerController: videoPlayerController!,
      aspectRatio: 2/1.6,
      // Prepare the video to be played and display the first frame
      autoInitialize: true,
      looping: false,
      autoPlay: false,
      // Errors can occur for example when trying to play a video
      // from a non-existent URL
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    //_chewieController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {



    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return new Padding(
            padding: const EdgeInsets.all(0.0),
            child: Chewie(
              key: new PageStorageKey(widget.url),
              controller:  _chewieController!,
            ),
          );
        }
        else {
          return Container(
            height: size.height*0.45,
            width: size.width*0.95,
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}