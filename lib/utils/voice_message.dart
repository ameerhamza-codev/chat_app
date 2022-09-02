import 'package:chat_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:timeago/timeago.dart';

import 'constants.dart';

class AudioBubble extends StatefulWidget {
  const AudioBubble({Key? key, required this.filepath,required this.timeStamp}) : super(key: key);

  final String filepath;final int timeStamp;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    player.setUrl(widget.filepath).then((value) {
      setState(() {
        duration = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 4),
          Row(
            children: [
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return GestureDetector(
                      child: const Icon(Icons.play_arrow),
                      onTap: player.play,
                    );
                  } else if (playing != true) {
                    return GestureDetector(
                      child: const Icon(Icons.play_arrow),
                      onTap: player.play,
                    );
                  } else if (processingState !=
                      ProcessingState.completed) {
                    return GestureDetector(
                      child: const Icon(Icons.pause),
                      onTap: player.pause,
                    );
                  } else {
                    return GestureDetector(
                      child: const Icon(Icons.replay),
                      onTap: () {
                        player.seek(Duration.zero);
                      },
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: snapshot.data!.inMilliseconds /
                                (duration?.inMilliseconds ?? 1),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prettyDuration(
                                    snapshot.data! == Duration.zero
                                        ? duration ?? Duration.zero
                                        : snapshot.data!),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                format(DateTime.fromMillisecondsSinceEpoch(widget.timeStamp)).toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  /*Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.4),
          Expanded(
            child: Container(
              height: 45,
              margin: EdgeInsets.fromLTRB(widget.isMe ? 20 : 10, 5, widget.isMe ? 10 : 20, 5),
              padding: const EdgeInsets.only(left: 12, right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),

                color: widget.isMe ? meChatBubble : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return GestureDetector(
                              child: const Icon(Icons.play_arrow),
                              onTap: player.play,
                            );
                          } else if (playing != true) {
                            return GestureDetector(
                              child: const Icon(Icons.play_arrow),
                              onTap: player.play,
                            );
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return GestureDetector(
                              child: const Icon(Icons.pause),
                              onTap: player.pause,
                            );
                          } else {
                            return GestureDetector(
                              child: const Icon(Icons.replay),
                              onTap: () {
                                player.seek(Duration.zero);
                              },
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StreamBuilder<Duration>(
                          stream: player.positionStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: snapshot.data!.inMilliseconds /
                                        (duration?.inMilliseconds ?? 1),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        prettyDuration(
                                            snapshot.data! == Duration.zero
                                                ? duration ?? Duration.zero
                                                : snapshot.data!),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        format(DateTime.fromMillisecondsSinceEpoch(widget.timeStamp)).toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const LinearProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),*/


}