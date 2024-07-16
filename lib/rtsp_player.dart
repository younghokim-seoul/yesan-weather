import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:yesan_weather/vlc_player_with_controls.dart';

class RtspPlayer extends ConsumerStatefulWidget {
  const RtspPlayer({super.key,required this.rtspLink});

  final String rtspLink;

  @override
  ConsumerState createState() => _RtspPlayerState();
}

class _RtspPlayerState extends ConsumerState<RtspPlayer> {

  late VlcPlayerController _vlcPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vlcPlayerController = VlcPlayerController.network(
      widget.rtspLink,
      hwAcc: HwAcc.full,
      autoPlay: false,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(10000),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return VlcPlayerWithControls(controller: _vlcPlayerController);
  }
}
