import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yesan_weather/main.dart';
import 'package:yesan_weather/rtsp_player.dart';
import 'package:yesan_weather/utill/transition.dart';

final smartKeyProvider = Provider((ref) => GlobalKey());

class SmartSystemView extends ConsumerStatefulWidget {
  const SmartSystemView({super.key, required this.schema});

  final List<String> schema;

  @override
  ConsumerState createState() => _SmartSystemViewState();
}

class _SmartSystemViewState extends ConsumerState<SmartSystemView> {
  late InAppWebViewController _webViewController;
  double progress = 0;
  final InAppWebViewSettings _options = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    // URL 로딩 제어
    mediaPlaybackRequiresUserGesture: false,
    // 미디어 자동 재생
    javaScriptEnabled: true,
    // 자바스크립트 실행 여부
    javaScriptCanOpenWindowsAutomatically: true,
    // 팝업 여부
    useHybridComposition: true,
    // 하이브리드 사용을 위한 안드로이드 웹뷰 최적화
    supportMultipleWindows: true,
    // 멀티 윈도우 허용
    allowsInlineMediaPlayback: true, // 웹뷰 내 미디어 재생 허용
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (await _webViewController.canGoBack()) {
            await _webViewController.goBack();
          } else {
            exit(0);
          }
        },
        child: Stack(
          children: [
            InAppWebView(
              key: ref.watch(smartKeyProvider),
              initialUrlRequest: URLRequest(url: WebUri(widget.schema[0])),
              initialSettings: _options,
              onLoadStop: (InAppWebViewController controller, uri) {
                log.i("onLoadStop $uri");
              },
              onLoadStart: (InAppWebViewController controller, uri) {
                log.i("onLoadStart $uri");
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                String requestUrl = navigationAction.request.url.toString();

                log.i("shouldOverrideUrlLoading $requestUrl");

                if (isAppLink(requestUrl)) {
                  log.i("isAppLink $requestUrl");
                  Navigator.push(
                      context,
                      SlideRightTransRoute(
                          builder: (context) => RtspPlayer(
                                rtspLink: widget.schema[1],
                              ),
                          settings: const RouteSettings()));
                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
          ],
        ),
      )),
    );
  }
}

bool isAppLink(String url) {
  List<String> splitUrl = url.replaceFirst(RegExp(r'://'), ' ').split(' ');
  String appScheme = splitUrl[0];

  log.d("appScheme: $appScheme");

  String? scheme;
  try {
    scheme = Uri.parse(url).scheme;
  } catch (e) {
    scheme = appScheme;
  }
  return !['http', 'https', 'about', 'data', ''].contains(scheme);
}
