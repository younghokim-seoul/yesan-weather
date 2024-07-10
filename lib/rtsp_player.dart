import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class RtspPlayer extends ConsumerStatefulWidget {
  const RtspPlayer({super.key});

  @override
  ConsumerState createState() => _RtspPlayerState();
}

class _RtspPlayerState extends ConsumerState<RtspPlayer> {

  VlcPlayerController? _vlcPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final controller = VlcPlayerController.network(
      'rtsp://admin:1q2w3e4r5t!@59.4.136.162:554/video1',
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
    _vlcPlayerController?.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
